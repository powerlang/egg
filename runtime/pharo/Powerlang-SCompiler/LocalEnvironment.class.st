Class {
	#name : 'LocalEnvironment',
	#superclass : 'Object',
	#pools : [
		'ClosureElementTypes'
	],
	#category : 'Powerlang-SCompiler-Bindings',
	#package : 'Powerlang-SCompiler',
	#tag : 'Bindings'
}

{ #category : 'testing' }
LocalEnvironment >> isInlinedArgument [
	^false
]
