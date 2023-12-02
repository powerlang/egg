Class {
	#name : #TCPTimestamp,
	#superclass : #TCPOption,
	#category : 'SqueakNOS-Net-Options-TCP'
}

{ #category : #accessing }
TCPTimestamp class >> length [
	^ 10
]

{ #category : #accessing }
TCPTimestamp class >> type [
	^ 8
]

{ #category : #accessing }
TCPTimestamp >> echo [
	^ self longAt: 7
]

{ #category : #accessing }
TCPTimestamp >> echo: anInteger [
	self longAt: 7 put: anInteger
]

{ #category : #printing }
TCPTimestamp >> printOn: aStream [
	aStream nextPutAll: '{TSval='; print: self value.
	self echo = 0 ifFalse: [aStream nextPutAll: ',TSecr='; print: self echo].
	aStream nextPut: $}
]

{ #category : #accessing }
TCPTimestamp >> value [
	^ self longAt: 3
]

{ #category : #accessing }
TCPTimestamp >> value: anInteger [
	self longAt: 3 put: anInteger
]
