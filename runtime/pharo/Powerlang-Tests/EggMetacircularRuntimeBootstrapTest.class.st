Class {
	#name : #EggMetacircularRuntimeBootstrapTest,
	#superclass : #TestCase,
	#instVars : [
		'runtime',
		'bootstrapper'
	],
	#category : 'Powerlang-Tests-Bootstrap'
}

{ #category : #accessing }
EggMetacircularRuntimeBootstrapTest class >> defaultTimeLimit [
	^ 1000 seconds
]

{ #category : #tests }
EggMetacircularRuntimeBootstrapTest >> setUp [
	bootstrapper := EggMetacircularRuntimeTestResource new
		setUp;
		bootstrapper.
	runtime := bootstrapper result.
]

{ #category : #tests }
EggMetacircularRuntimeBootstrapTest >> test010GenenerateKernelSegment [

	| output module  |
	output := bootstrapper outputDirectory / 'bootstrap' / 'Kernel.is'.
	output exists ifTrue: [ output deleteFile ].
	bootstrapper useHostModuleLoader.
	module := bootstrapper sendLoadModule: #ImageSegmentBuilder
	"json := runtime sendLocal: #writeJSONKernel to: module.
	self assert: json whatever"
]
