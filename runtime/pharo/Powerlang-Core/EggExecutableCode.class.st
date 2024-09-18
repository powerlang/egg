Class {
	#name : 'EggExecutableCode',
	#superclass : 'EggHeapObject',
	#instVars : [
		'code'
	],
	#category : 'Powerlang-Core-Execution-Metacircular',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Metacircular'
}

{ #category : 'accessing' }
EggExecutableCode >> code [
	^code
]

{ #category : 'accessing' }
EggExecutableCode >> code: anObject [
	code := anObject
]
