Class {
	#name : #WindowScale,
	#superclass : #TCPOption,
	#category : 'SqueakNOS-Net-Options-TCP'
}

{ #category : #accessing }
WindowScale class >> length [
	^ 3
]

{ #category : #accessing }
WindowScale class >> type [
	^ 3
]

{ #category : #accessing }
WindowScale >> factor [
	^ 1 bitShift: self shift
]

{ #category : #accessing }
WindowScale >> factor: anInteger [
	self shift: anInteger highBit - 1
]

{ #category : #printing }
WindowScale >> printOn: aStream [
	aStream nextPutAll: '{WSopt='; print: self factor; nextPut: $}
]

{ #category : #accessing }
WindowScale >> shift [
	^ self at: 3
]

{ #category : #accessing }
WindowScale >> shift: anInteger [
	self at: 3 put: anInteger
]
