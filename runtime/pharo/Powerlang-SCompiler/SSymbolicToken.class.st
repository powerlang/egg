Class {
	#name : 'SSymbolicToken',
	#superclass : 'SToken',
	#instVars : [
		'value'
	],
	#category : 'Powerlang-SCompiler-Parser',
	#package : 'Powerlang-SCompiler',
	#tag : 'Parser'
}

{ #category : 'testing' }
SSymbolicToken >> is: anObject [
	^value == anObject
]

{ #category : 'accessing' }
SSymbolicToken >> value [
	^value
]

{ #category : 'accessing' }
SSymbolicToken >> value: anObject [
	value := anObject
]
