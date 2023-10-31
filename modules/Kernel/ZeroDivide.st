"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ZeroDivide,
	#superclass : #ArithmeticError,
	#instVars : [
		'dividend'
	],
	#category : #Kernel
}

{ #category : #accessing }
ZeroDivide >> dividend [
	^dividend
]

{ #category : #accessing }
ZeroDivide >> dividend: aNumber [
	dividend := aNumber
]

{ #category : #initialization }
ZeroDivide >> initialize [
	super initialize.
	description := 'Floating Point exception when trying to divide by zero'
]

{ #category : #testing }
ZeroDivide >> isResumable [
	^true
]

{ #category : #accessing }
ZeroDivide >> operation: aSymbol [
	super operation: aSymbol.
	description := aSymbol == #'/'
		ifTrue: ['Floating Point exception when trying to divide by zero']
		ifFalse: ['Divide by Zero exception in ''' , aSymbol , ''' operation']
]

