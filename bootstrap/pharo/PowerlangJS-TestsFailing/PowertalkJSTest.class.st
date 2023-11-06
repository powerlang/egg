Class {
	#name : #PowertalkJSTest,
	#superclass : #TestCase,
	#instVars : [
		'runtime',
		'bootstrapper'
	],
	#category : #'PowerlangJS-TestsFailing'
}

{ #category : #accessing }
PowertalkJSTest class >> defaultTimeLimit [
	^ 1000 seconds
]

{ #category : #tests }
PowertalkJSTest >> setUp [
	bootstrapper := PowertalkLMRTestResource new
		setUp;
		bootstrapper.
	runtime := bootstrapper result.
]

{ #category : #tests }
PowertalkJSTest >> test010WriteKernelAsJSON [

	| output module json |
	output := bootstrapper rootDirectory / 'LMRjs' / 'Kernel.json'.
	output exists ifTrue: [ output delete ].

	module := bootstrapper sendLoadModule: #ImageSegmentBuilder.
	json := runtime sendLocal: #writeJSONKernel to: module
	"self assert: output exists"
]
