Class {
	#name : #PowerlangDebuggerWrapper,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Powerlang-EggWebside-Base'
}

{ #category : #accessing }
PowerlangDebuggerWrapper >> context [
	^context
]

{ #category : #accessing }
PowerlangDebuggerWrapper >> context: anEvaluatorContext [

	context := anEvaluatorContext
]
