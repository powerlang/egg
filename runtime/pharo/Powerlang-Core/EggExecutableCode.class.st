Class {
	#name : #EggExecutableCode,
	#superclass : #EggHeapObject,
	#instVars : [
		'code'
	],
	#category : #'Powerlang-Core-Execution-LMR'
}

{ #category : #accessing }
EggExecutableCode >> code [
	^code
]

{ #category : #accessing }
EggExecutableCode >> code: anObject [
	code := anObject
]
