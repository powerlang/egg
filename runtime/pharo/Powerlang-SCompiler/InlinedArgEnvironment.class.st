Class {
	#name : 'InlinedArgEnvironment',
	#superclass : 'StackEnvironment',
	#category : 'Powerlang-SCompiler-Bindings',
	#package : 'Powerlang-SCompiler',
	#tag : 'Bindings'
}

{ #category : 'accessing' }
InlinedArgEnvironment >> environmentType [
	^InlinedArgument
]

{ #category : 'accessing' }
InlinedArgEnvironment >> isInlinedArgument [
	^true
]
