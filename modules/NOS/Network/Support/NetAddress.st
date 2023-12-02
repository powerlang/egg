Class {
	#name : #NetAddress,
	#superclass : #ArrayedCollection,
	#instVars : [
		'bytes'
	],
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #'instance creation' }
NetAddress class >> bytes: aByteArray [
	^ self new bytes: aByteArray
]

{ #category : #accessing }
NetAddress class >> type [
	^ nil
]

{ #category : #arithmetic }
NetAddress >> & aNetAddress [
	| newBytes |
	newBytes := ByteArray new: bytes size.
	1 to: bytes size do: [ :each | newBytes at: each put: ((bytes at: each) bitAnd: (aNetAddress bytes at: each))].
	^ self class bytes: newBytes
]

{ #category : #converting }
NetAddress >> / anInteger [
	^ NetBlock new address: self; mask: (self class bytes: (BitArray new: self size * 8 with: (1 bitShift: anInteger) - 1) asByteArray)
]

{ #category : #comparing }
NetAddress >> = aNetAddress [
	^ self class = aNetAddress class and: [bytes = aNetAddress bytes]
]

{ #category : #converting }
NetAddress >> asByteArray [
	^ bytes
]

{ #category : #accessing }
NetAddress >> at: anInteger [
	^ bytes at: anInteger
]

{ #category : #accessing }
NetAddress >> at: anInteger put: byte [
	^ self shouldNotImplement
]

{ #category : #accessing }
NetAddress >> bytes [
	^ bytes
]

{ #category : #accessing }
NetAddress >> bytes: aByteArray [
	bytes := aByteArray asByteArray
]

{ #category : #comparing }
NetAddress >> hash [
	^ bytes hash
]

{ #category : #arithmetic }
NetAddress >> not [
	^ self class bytes: (bytes collect: [ :each | each bitInvert])
]

{ #category : #accessing }
NetAddress >> size [
	^ bytes size
]

{ #category : #arithmetic }
NetAddress >> xor: aNetAddress [
	| newBytes |
	newBytes := ByteArray new: bytes size.
	1 to: bytes size do: [ :each | newBytes at: each put: ((bytes at: each) bitXor: (aNetAddress bytes at: each))].
	^ self class bytes: newBytes
]

{ #category : #arithmetic }
NetAddress >> | aNetAddress [
	| newBytes |
	newBytes := ByteArray new: bytes size.
	1 to: bytes size do: [ :each | newBytes at: each put: ((bytes at: each) bitOr: (aNetAddress bytes at: each))].
	^ self class bytes: newBytes
]
