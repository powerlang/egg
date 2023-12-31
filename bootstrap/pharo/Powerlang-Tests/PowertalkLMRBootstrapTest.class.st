Class {
	#name : #PowertalkLMRBootstrapTest,
	#superclass : #TestCase,
	#instVars : [
		'runtime',
		'bootstrapper'
	],
	#category : #'Powerlang-Tests-Bootstrap'
}

{ #category : #accessing }
PowertalkLMRBootstrapTest class >> defaultTimeLimit [
	^ 1000 seconds
]

{ #category : #tests }
PowertalkLMRBootstrapTest >> setUp [
	bootstrapper := PowertalkLMRTestResource new
		setUp;
		bootstrapper.
	runtime := bootstrapper result.
]

{ #category : #tests }
PowertalkLMRBootstrapTest >> test010GenenerateKernelSegment [

	| output module  |
	output := bootstrapper outputDirectory / 'bootstrap' / 'Kernel.is'.
	output exists ifTrue: [ output deleteFile ].
	bootstrapper useHostModuleLoader.
	module := bootstrapper sendLoadModule: #ImageSegmentBuilder
	"json := runtime sendLocal: #writeJSONKernel to: module.
	self assert: json whatever"
]
