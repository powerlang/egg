Class {
	#name : #NetBlock,
	#superclass : #ArrayedCollection,
	#instVars : [
		'address',
		'mask'
	],
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #accessing }
NetBlock >> address [
	^ address
]

{ #category : #accessing }
NetBlock >> address: aNetAddress [
	address := aNetAddress
]

{ #category : #accessing }
NetBlock >> at: anInteger [
	| bits orBits newBit |
	bits := anInteger.
	orBits := (BitArray bytes: mask bytes reversed)
		collect: [ :each |
			each = 0
				ifTrue: [newBit := bits bitAnd: 1. bits := bits bitShift: -1. newBit]
				ifFalse: [0]].
	^ address & mask | (NetAddress bytes: orBits asByteArray reversed)
]

{ #category : #accessing }
NetBlock >> broadcast [
	^ self at: self size - 1
]

{ #category : #testing }
NetBlock >> includes: aNetAddress [
	^ aNetAddress & mask = address
]

{ #category : #accessing }
NetBlock >> mask [
	^ mask
]

{ #category : #accessing }
NetBlock >> mask: aNetAddress [
	mask := aNetAddress
]

{ #category : #printing }
NetBlock >> printOn: aStream [
	| bits index |
	aStream print: address.
	bits := BitArray bytes: mask bytes.
	index := bits findLast: [ :one | one = 1].
	index + 1 = (bits findFirst: [ :one | one = 0])
		ifTrue: [aStream nextPut: $/; print: index]
		ifFalse: [aStream space; print: mask]
]

{ #category : #accessing }
NetBlock >> size [
	^ 2 raisedTo: ((BitArray bytes: mask bytes) occurrencesOf: 0)
]
