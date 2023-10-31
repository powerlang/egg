"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #KeyNotFound,
	#superclass : #Error,
	#instVars : [
		'object'
	],
	#category : #Kernel
}

{ #category : #signaling }
KeyNotFound class >> signalFor: anObject [
	^self new object: anObject; signal
]

{ #category : #accessing }
KeyNotFound >> defaultDescription [
	| string |
	string := [object printString] on: Error do: [:ex | ex description].
	^'Key ' , string , ' is missing'
]

{ #category : #accessing }
KeyNotFound >> object: anObject [
	object := anObject
]

