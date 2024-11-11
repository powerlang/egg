Class {
	#name : #ArgumentEnvironment,
	#superclass : #StackEnvironment,
	#category : #'Powerlang-Core-SCompiler'
}

{ #category : #private }
ArgumentEnvironment >> captureType [
	^CaptureLocalArgument
]
