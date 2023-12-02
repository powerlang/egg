Class {
	#name : #SACK,
	#superclass : #TCPOption,
	#category : 'SqueakNOS-Net-Options-TCP'
}

{ #category : #accessing }
SACK class >> length [
	^ self shouldNotImplement
]

{ #category : #'instance creation' }
SACK class >> new: anInteger [
	| length |
	length := anInteger * 4 * 2 + 2.
	^ self bytes:
		((ByteArray new: length)
				at: 1 put: self type;
				at: 2 put: length;
				yourself)
]

{ #category : #accessing }
SACK class >> type [
	^ 5
]

{ #category : #accessing }
SACK >> blockAt: anInteger [
	| firstIndex |
	firstIndex := anInteger - 1 * 8 + 2 + 1.
	^ Interval
		from: (TCPSequenceNumber value: (self longAt: firstIndex))
		to: (TCPSequenceNumber value: (self longAt: firstIndex + 4))
]

{ #category : #accessing }
SACK >> blocks [
	^ (1 to: self numberOfBlocks) collect: [ :each | self blockAt: each]
]

{ #category : #accessing }
SACK >> numberOfBlocks [
	^ self size - 2 // 8
]

{ #category : #printing }
SACK >> printOn: aStream [
	aStream nextPutAll: '{SACK'.
	self numberOfBlocks > 0 ifFalse: [aStream nextPut: $=].
	self blocks do: [ :each | aStream print: each first; nextPut: $-; print: each last] separatedBy: [aStream nextPut: $,].
	aStream nextPut: $}
]
