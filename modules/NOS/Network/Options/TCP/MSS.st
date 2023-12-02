Class {
	#name : #MSS,
	#superclass : #TCPOption,
	#category : 'SqueakNOS-Net-Options-TCP'
}

{ #category : #accessing }
MSS class >> length [
	^ 4
]

{ #category : #accessing }
MSS class >> type [
	^ 2
]

{ #category : #printing }
MSS >> printOn: aStream [
	aStream nextPutAll: '{MSS='; print: self value; nextPut: $}
]

{ #category : #accessing }
MSS >> value [
	^ self shortAt: 3
]

{ #category : #accessing }
MSS >> value: anInteger [
	self shortAt: 3 put: anInteger
]
