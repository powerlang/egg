Class {
	#name : 'EggModuleTest',
	#superclass : 'TestCase',
	#instVars : [
		'runtime',
		'bootstrapper'
	],
	#category : 'Powerlang-Tests-Bootstrap',
	#package : 'Powerlang-Tests',
	#tag : 'Bootstrap'
}

{ #category : 'accessing' }
EggModuleTest class >> defaultTimeLimit [
	^ 1000 seconds
]

{ #category : 'running' }
EggModuleTest >> setUp [

	| image |
	super setUp.
	image := EggBootstrapImage fromSpec
		         wordSize: 8;
		         genesis;
		         bootstrap;
		         fillClasses;
		         fillSymbols.
	bootstrapper := image generateMetacircularImage.
	runtime := bootstrapper result.
	bootstrapper useHostModuleLoader
]

{ #category : 'running' }
EggModuleTest >> test010LoadClassAndMethod [

	| st p module classes class a str |
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
	classes := runtime sendLocal: #classes to: module.
	class := runtime sendLocal: #first to: classes.
	a := runtime sendLocal: #new to: class.
	str := runtime sendLocal: #a to: a.
	self assert: str asLocalString equals: 'a'
]

{ #category : 'running' }
EggModuleTest >> test020LoadClassMethodAndRequire [

	| st p module classes class b str |
	(bootstrapper rootDirectory / 'B') ensureCreateDirectory.
	st := bootstrapper rootDirectory / 'B/B.st'.
	st
		createFile;
		writeStreamDo: [ :s | 
			s
				truncate;
				nextPutAll: 'Class {
	#name : #B,
	#superclass : #A,
	#instVars : [],
	#category : #''B''
}
{ #category : #accessing }
B >> a [
	^super a, ''b''
] ' ].
	st := bootstrapper rootDirectory / 'B/ModuleB.st'.
	st
		createFile;
		writeStreamDo: [ :s | 
			s
				truncate;
				nextPutAll: 'Class {
	#name : #ModuleB,
	#superclass : #Module,
	#instVars : [],
	#category : #''B''
}
{ #category : #initializing }
ModuleB >> initialize [
	super initialize.
	requires := #(''A'')
]
{ #category : #spec }
ModuleB >> imports [
	^{#A -> #A. #Kernel -> #Module}
] ' ].
	p := bootstrapper rootDirectory / 'B/package.st'.
	p
		createFile;
		writeStreamDo: [ :s | 
			s
				truncate;
				nextPutAll: 'Package {
	#name : #B,
	#classes : [
		''B''
	]
}' ].
	module := bootstrapper sendLoadModule: #B.
	classes := runtime sendLocal: #classes to: module.
	class := runtime sendLocal: #second to: classes.
	b := runtime sendLocal: #new to: class.
	str := runtime sendLocal: #a to: b.
	self assert: str asLocalString equals: 'ab'
]

{ #category : 'running' }
EggModuleTest >> test100LoadCompiler [

	| module namespace name compiler object code method foo |

	module := bootstrapper sendLoadModule: #Compiler.
	namespace := runtime sendLocal: #namespace to: module.
	name := runtime addSymbol: #SCompiler.
	compiler := runtime sendLocal: #at: to: namespace with: { name }.
	object := bootstrapper => #Object.
	code := runtime newString: 'foo ^''foo'''.
	method := runtime sendLocal: #compile:in: to: compiler with: { 
			          code.
			          object }.
	runtime sendLocal: #install to: method.
	foo := runtime sendLocal: #foo to: object.
	self assert: foo asLocalString equals: 'foo'
]
