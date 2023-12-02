Class {
	#name : #TCPSequenceNumber,
	#superclass : #Magnitude,
	#instVars : [
		'value'
	],
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #'instance creation' }
TCPSequenceNumber class >> value: anInteger [
	^ self new setValue: anInteger
]

{ #category : #arithmetic }
TCPSequenceNumber >> + anInteger [
	^ self class value: value + anInteger asInteger \\ 16r100000000
]

{ #category : #arithmetic }
TCPSequenceNumber >> - anInteger [
	^ self class value: value - anInteger asInteger \\ 16r100000000
]

{ #category : #comparing }
TCPSequenceNumber >> < aNumber [
	^ value ~= aNumber asInteger and: [aNumber asInteger - value \\ 16r100000000 < 16r80000000]
]

{ #category : #comparing }
TCPSequenceNumber >> = aNumber [
	^ value = aNumber asInteger
]

{ #category : #converting }
TCPSequenceNumber >> adaptToInteger: rcvr andSend: selector [
	^ self class value: (rcvr perform: selector with: value) \\ 16r100000000
]

{ #category : #converting }
TCPSequenceNumber >> asInteger [
	^ value
]

{ #category : #comparing }
TCPSequenceNumber >> hash [
	^ value hash
]

{ #category : #printing }
TCPSequenceNumber >> printOn: aStream [
	aStream nextPut: $[; print: self asInteger; nextPut: $]
]

{ #category : #initialization }
TCPSequenceNumber >> setValue: anInteger [
	value := anInteger asInteger
]
