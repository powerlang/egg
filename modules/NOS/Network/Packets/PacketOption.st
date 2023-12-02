Class {
	#name : #PacketOption,
	#superclass : #ArrayedCollection,
	#instVars : [
		'bytes',
		'offset'
	],
	#category : 'SqueakNOS-Net-Packets'
}

{ #category : #'instance creation' }
PacketOption class >> bytes: aByteArray [
	^ self bytes: aByteArray offset: 0
]

{ #category : #'instance creation' }
PacketOption class >> bytes: aByteArray offset: anInteger [
	^ self basicNew bytes: aByteArray; offset: anInteger
]

{ #category : #accessing }
PacketOption >> at: anInteger [
	^ bytes at: anInteger + offset
]

{ #category : #accessing }
PacketOption >> at: anInteger put: anObject [
	^ bytes at: anInteger + offset put: anObject
]

{ #category : #'accessing-private' }
PacketOption >> bytes: aByteArray [
	bytes := aByteArray
]

{ #category : #accessing }
PacketOption >> length [
	^ self type > 1 ifTrue: [self at: 2] ifFalse: [1]
]

{ #category : #accessing }
PacketOption >> length: anInteger [
	self at: 2 put: anInteger
]

{ #category : #accessing }
PacketOption >> longAt: anInteger [
	^ (self shortAt: anInteger) * 16r10000 + (self shortAt: anInteger + 2)
]

{ #category : #accessing }
PacketOption >> longAt: anInteger put: aLong [
	self shortAt: anInteger put: aLong // 16r10000.
	self shortAt: anInteger+2 put: aLong \\ 16r10000.
	^ aLong
]

{ #category : #accessing }
PacketOption >> name [
	^ self type asString
]

{ #category : #'accessing-private' }
PacketOption >> offset: anInteger [
	offset := anInteger
]

{ #category : #printing }
PacketOption >> printOn: aStream [
	aStream nextPutAll: '{', self name, '}'
]

{ #category : #accessing }
PacketOption >> shortAt: anInteger [
	^ (self at: anInteger) * 256 + (self at: anInteger+1)
]

{ #category : #accessing }
PacketOption >> shortAt: anInteger put: aShort [
	self at: anInteger put: aShort // 256.
	self at: anInteger+1 put: aShort \\ 256.
	^ aShort
]

{ #category : #accessing }
PacketOption >> size [
	^ self length
]

{ #category : #private }
PacketOption >> species [
	^ ByteArray
]

{ #category : #accessing }
PacketOption >> type [
	^ self at: 1
]

{ #category : #accessing }
PacketOption >> type: anInteger [
	self at: 1 put: anInteger
]
