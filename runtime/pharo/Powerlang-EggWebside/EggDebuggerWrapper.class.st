Class {
	#name : #EggDebuggerWrapper,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Powerlang-EggWebside-Base'
}

{ #category : #accessing }
EggDebuggerWrapper >> context [
	^context
]

{ #category : #accessing }
EggDebuggerWrapper >> context: anEvaluatorContext [

	context := anEvaluatorContext
]
