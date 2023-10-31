"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ArithmeticError,
	#superclass : #Error,
	#instVars : [
		'operation',
		'type'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ArithmeticError class >> on: aSymbol [
	^self new operation: aSymbol
]

{ #category : #private }
ArithmeticError >> getDescription [
	| string |
	string := self typeDescription.
	operation notNil
		ifTrue: [string := string , ' in ''' , operation , ''' operation'].
	^string
]

{ #category : #accessing }
ArithmeticError >> operation: aSymbol [
	operation := aSymbol
]

{ #category : #printing }
ArithmeticError >> printOn: aStream [
	aStream nextPutAll: self class name; space.
	type notNil ifTrue: [type printOn: aStream]
]

{ #category : #signaling }
ArithmeticError >> signalCoprocessorMissing [
	^self type: #coprocessor; signal
]

{ #category : #signaling }
ArithmeticError >> signalDenormalized [
	^self type: #denormalized; signal
]

{ #category : #signaling }
ArithmeticError >> signalInexactOperation [
	^self type: #inexact; signal
]

{ #category : #signaling }
ArithmeticError >> signalInvalidOperation [
	^self type: #invalid; signal
]

{ #category : #signaling }
ArithmeticError >> signalOverflow [
	^self type: #overflow; signal
]

{ #category : #signaling }
ArithmeticError >> signalUndefined [
	^self type: #undefined; signal
]

{ #category : #signaling }
ArithmeticError >> signalUnderflow [
	^FloatUnderflow signal
]

{ #category : #accessing }
ArithmeticError >> type [
	^type
]

{ #category : #accessing }
ArithmeticError >> type: aSymbol [
	type := aSymbol.
	description := self getDescription
]

{ #category : #private }
ArithmeticError >> typeDescription [
	type == #overflow ifTrue: [^'Floating Point overflow exception'].
	type == #underflow ifTrue: [^'Floating Point underflow exception'].
	type == #denormalized ifTrue: [^'Floating Point denormalized operand'].
	type == #invalid ifTrue: [^'Floating Point invalid operation exception'].
	type == #undefined ifTrue: [^'Floating Point undefined exception'].
	type == #inexact ifTrue: [^'Floating Point inexact result'].
	type == #coprocessor ifTrue: [^'Math coprocessor missing'].
	^type printString , ' invalid type symbol'
]

