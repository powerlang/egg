Class {
	#name : #InlinedArgEnvironment,
	#superclass : #StackEnvironment,
	#category : #'Powerlang-Core-SCompiler'
}

{ #category : #accessing }
InlinedArgEnvironment >> captureType [
	^CaptureInlinedArgument
]

{ #category : #accessing }
InlinedArgEnvironment >> isInlinedArgument [
	^true
]
