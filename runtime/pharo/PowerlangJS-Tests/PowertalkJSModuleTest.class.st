Class {
	#name : #PowertalkJSModuleTest,
	#superclass : #TestCase,
	#instVars : [
		'runtime',
		'bootstrapper'
	],
	#category : #'PowerlangJS-Tests'
}

{ #category : #accessing }
PowertalkJSModuleTest class >> defaultTimeLimit [
	^ 1000 seconds
]

{ #category : #running }
PowertalkJSModuleTest >> setUp [

	| image |
	super setUp.
	image := PowertalkRingImage fromSpec
		         wordSize: 8;
		         genesis;
		         bootstrap;
		         fillClasses;
		         fillSymbols.
	bootstrapper := image generateLMR.
	runtime := bootstrapper result.
	bootstrapper useHostModuleLoader
]

{ #category : #running }
PowertalkJSModuleTest >> testWriteModuleSegment [

	| st p module json output builder |
	(bootstrapper rootDirectory / 'A') ensureCreateDirectory.
	st := bootstrapper rootDirectory / 'A/A.st'.
	st
		createFile;
		writeStreamDo: [ :s | 
			s nextPutAll: 'Class {
	#name : #A,
	#superclass : #Object,
	#instVars : [],
	#category : #''A''
}
{ #category : #accessing }
A >> a [
	^''a''
] ' ].
	p := bootstrapper rootDirectory / 'A/package.st'.
	p
		createFile;
		writeStreamDo: [ :s | 
			s nextPutAll: 'Package {
	#name : #A,
	#classes : [
		''A''
	]
}' ].
	module := bootstrapper sendLoadModule: #A.
	builder := bootstrapper sendLoadModule: #ImageSegmentBuilder.
	json := runtime
		        sendLocal: #writeJSONModule:
		        to: builder
		        with: { module }.
	output := JSTranspiler rootDirectory / 'image-segments/A.json'.
	output
		ensureCreateFile;
		writeStreamDo: [ :stream | 
			| ws |
			stream truncate.
			ws := ZnNewLineWriterStream on: stream.
			ws nextPutAll: json asLocalString ]
]
