Class {
	#name : #EggJSTest,
	#superclass : #TestCase,
	#instVars : [
		'runtime',
		'bootstrapper'
	],
	#category : #'PowerlangJS-TestsFailing'
}

{ #category : #accessing }
EggJSTest class >> defaultTimeLimit [
	^ 1000 seconds
]

{ #category : #tests }
EggJSTest >> setUp [
	bootstrapper := EggMetacircularRuntimeTestResource new
		setUp;
		bootstrapper.
	runtime := bootstrapper result.
]

{ #category : #tests }
EggJSTest >> test010WriteKernelAsJSON [

	| output module json |
	output := bootstrapper rootDirectory / 'LMRjs' / 'Kernel.json'.
	output exists ifTrue: [ output delete ].

	module := bootstrapper sendLoadModule: #ImageSegmentBuilder.
	json := runtime sendLocal: #writeJSONModule: to: module with: { bootstrapper result kernel }
	"self assert: output exists"
]
