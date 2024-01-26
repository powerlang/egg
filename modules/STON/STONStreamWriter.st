"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STONStreamWriter, 
	#superclass : #Object, 
	#instVars : [
		'writer', 
		'first'
	], 
	#category : #STON
}

{#category : #'instance creation'}
STONStreamWriter class >> new [
	^super new initialize
]

{#category : #'instance creation'}
STONStreamWriter class >> on: aSTONWriter [
	^self new on: aSTONWriter
]

{#category : #accessing}
STONStreamWriter >> add: anObject [
	first ifTrue: [first := false] ifFalse: [self comma].
	writer nextPut: anObject
]

{#category : #accessing}
STONStreamWriter >> at: key put: value [
	first ifTrue: [first := false] ifFalse: [self comma].
	writer encodeKey: key value: value
]

{#category : #accessing}
STONStreamWriter >> comma [
	writer comma
]

{#category : #initialization}
STONStreamWriter >> initialize [
	super initialize.
	first := true
]

{#category : #accessing}
STONStreamWriter >> on: aSTONWriter [
	writer := aSTONWriter
]

