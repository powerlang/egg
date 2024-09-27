"
I'm in charge of generating image segments for other VMs.

I know how to load the corresponding writer modules and then how to send the appropiate messages to the image-segment builder to write egg module snapshots to files.
"
Class {
	#name : 'EggBuilder',
	#superclass : 'Object',
	#instVars : [
		'runtime',
		'type',
		'writerModule'
	],
	#category : 'Powerlang-Core-Building',
	#package : 'Powerlang-Core',
	#tag : 'Building'
}

{ #category : 'instance creation' }
EggBuilder class >> forJSPlatform [
	^self new initializeDefaultRuntime; useJSONWriter
]

{ #category : 'instance creation' }
EggBuilder class >> forNativePlatform [
	^self new initializeDefaultRuntime; useNativeWriter
]

{ #category : 'services' }
EggBuilder >> generateCompilerSegment [

	self generateSegmentFromModuleNamed: 'Compiler'
]

{ #category : 'services' }
EggBuilder >> generateKernelSegment [

	self generateSegmentFromModuleNamed: 'Kernel'
]

{ #category : 'services' }
EggBuilder >> generateMainSegments [

	self generateSegmentsFromModulesNamed:
	#( 'ImageSegmentBuilder' 'ImageSegmentBuilder.JSON'
	   'STON' 'Tonel' 'CodeSpecs' 'CodeSpecsImporter' 'PetitParser' 'PetitParser.Extensions' 'PetitParser.Parsers' 'PetitParser.Tools' )
]

{ #category : 'services' }
EggBuilder >> generateSegmentFromModuleNamed: aString [

	| symbol module writer result extension |
	symbol := runtime addSymbol: aString.
	module := runtime sendLocal: #load: to: runtime kernel with: { symbol }.
	writer := runtime sendLocal: #newWriter to: writerModule.
	result := runtime sendLocal: #writeImageSegmentUsing: to: module with: { writer }.
	extension := runtime sendLocal: #fileExtension to: writerModule.
	self write: result into: (aString , '.', extension asLocalString).
]

{ #category : 'services' }
EggBuilder >> generateSegmentsFromModulesNamed: aCollection [

	aCollection do: [ :n | self generateSegmentFromModuleNamed: n ]
]

{ #category : 'private' }
EggBuilder >> imageSegmentDirectory [

	| dir |
	dir := Smalltalk os environment
		        at: 'IMAGE_SEGMENT_DIRECTORY'
		        ifAbsent: [self runtimeDirectory / 'image-segments'].
	^ dir asFileReference
]

{ #category : 'services' }
EggBuilder >> initializeDefaultRuntime [

	| bootstrapper builder |
	bootstrapper := self newDefaultMetacircularImage.
	runtime := bootstrapper result.

	runtime fixOverrides.
	bootstrapper useHostModuleLoader.
	builder := bootstrapper sendLoadModule: #ImageSegmentBuilder.
	^ runtime
]

{ #category : 'services' }
EggBuilder >> newDefaultMetacircularImage [

	| image |
	image := EggBootstrapImage fromSpec
		         wordSize: 8;
		         genesis;
		         bootstrap;
		         fillClasses;
		         fillSymbols.
	^ image generateMetacircularImage
]

{ #category : 'private' }
EggBuilder >> rootDirectory [
	| root |
	root := Smalltalk os environment at: 'POWERLANG_JS_ROOT' ifAbsent: '../../'.
	^ root asFileReference
]

{ #category : 'services' }
EggBuilder >> runtime: anEggRuntime [
	runtime := anEggRuntime
]

{ #category : 'private' }
EggBuilder >> runtimeDirectory [

	| subdirectory |
	subdirectory := type = #native 
		ifTrue: [ 'cpp' ] ifFalse: [ 'js' ].
	^ (self rootDirectory / 'runtime' / subdirectory) asFileReference
]

{ #category : 'services' }
EggBuilder >> useJSONWriter [

	| symbol |
	type := #json.
	symbol := runtime addSymbol: #'ImageSegmentBuilder.JSON'.
	writerModule := runtime
		          sendLocal: #load:
		          to: runtime kernel
		          with: { symbol }
]

{ #category : 'services' }
EggBuilder >> useNativeWriter [

	| symbol |
	type := #native.
	symbol := runtime addSymbol: #'ImageSegmentBuilder.Native'.
	writerModule := runtime sendLocal: #load: to: runtime kernel with: { symbol }.
	

]

{ #category : 'services' }
EggBuilder >> write: result into: filename [
	| file utf |
	file := self imageSegmentDirectory / filename.
	file ensureCreateFile.
	type = #native 
		ifTrue: [ 
			file binaryWriteStreamDo: [ :stream |
				stream truncate; nextPutAll: result bytes ]]
		ifFalse: [
			file writeStreamDo: [ :stream |
				stream truncate.
				utf := ZnNewLineWriterStream on: stream.
				utf nextPutAll: result asLocalString ]]
				
]
