Class {
	#name : #LMRExecutableCode,
	#superclass : #LMRHeapObject,
	#instVars : [
		'code'
	],
	#category : #'Powerlang-Core-Execution-Metacircular'
}

{ #category : #accessing }
LMRExecutableCode >> code [
	^code
]

{ #category : #accessing }
LMRExecutableCode >> code: anObject [
	code := anObject
]
