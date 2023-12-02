Class {
	#name : #BitArray,
	#superclass : #ArrayedCollection,
	#instVars : [
		'contents',
		'bitSize'
	],
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #'instance creation' }
BitArray class >> byte: anInteger [
	^ self new: 8 with: anInteger
]

{ #category : #'instance creation' }
BitArray class >> bytes: aByteArray [
	| integer |
	integer := 0.
	aByteArray reverseDo: [ :each | integer _ integer * 256 + each].
	^ self new: aByteArray size * 8 with: integer
]

{ #category : #'instance creation' }
BitArray class >> double: anInteger [
	^ self new: 32 with: anInteger
]

{ #category : #'instance creation' }
BitArray class >> new: anInteger [
	^ self basicNew initialize: anInteger
]

{ #category : #'instance creation' }
BitArray class >> new: bitSize with: bits [
	^ (self new: bitSize) contents: bits
]

{ #category : #'instance creation' }
BitArray class >> quad: anInteger [
	^ self new: 64 with: anInteger
]

{ #category : #'instance creation' }
BitArray class >> word: anInteger [
	^ self new: 16 with: anInteger
]

{ #category : #converting }
BitArray >> asByteArray [
	^ ((1 to: self byteSize) collect: [ :each | self atByte: each]) asByteArray
]

{ #category : #converting }
BitArray >> asInteger [
	^ contents
]

{ #category : #accessing }
BitArray >> at: anInteger [
	^ (contents bitShift: 1-anInteger) bitAnd: 1
]

{ #category : #accessing }
BitArray >> at: anInteger put: bit [
	contents := contents bitOr: (bit bitShift: anInteger-1).
	^ bit
]

{ #category : #accessing }
BitArray >> atByte: anInteger [
	^ (contents bitShift: 1-anInteger*8) bitAnd: 16rFF
]

{ #category : #accessing }
BitArray >> atByte: anInteger put: byte [
	contents := contents bitOr: (byte bitShift: anInteger-1*8).
	^ byte
]

{ #category : #accessing }
BitArray >> bitSize [
	^ bitSize
]

{ #category : #accessing }
BitArray >> byteSize [
	^ self bitSize - 1 // 8 + 1
]

{ #category : #initialization }
BitArray >> contents: anInteger [
	contents := anInteger
]

{ #category : #printing }
BitArray >> hex [
	| stream |
	stream := WriteStream with: '16r'.
	self asByteArray do: [ :each |
		stream
			nextPut: ('0123456789ABCDEF' at: each // 16 + 1);
			nextPut: ('0123456789ABCDEF' at: each \\ 16 + 1)].
	^ stream contents


]

{ #category : #initialization }
BitArray >> initialize: anInteger [
	bitSize := anInteger.
	contents := 0
]

{ #category : #accessing }
BitArray >> size [
	^ self bitSize
]
