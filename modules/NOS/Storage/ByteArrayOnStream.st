Class {
	#name : #ByteArrayOnStream,
	#superclass : #ArrayedCollection,
	#instVars : [
		'stream'
	],
	#category : #'SqueakNOS-Storage'
}

{ #category : #'instance creation' }
ByteArrayOnStream class >> on: aStream [
	^ self new stream: aStream
]

{ #category : #accessing }
ByteArrayOnStream >> at: anInteger [
	^ self byteAt: anInteger
]

{ #category : #converting }
ByteArrayOnStream >> at: anInteger put: byte [
	^self byteAt: anInteger put: byte
]

{ #category : #accessing }
ByteArrayOnStream >> byteAt: index [
	^stream position: index - 1; next
]

{ #category : #accessing }
ByteArrayOnStream >> byteAt: index put: anInteger [
	^ stream
		position: index - 1;
		nextPut: anInteger
]

{ #category : #accessing }
ByteArrayOnStream >> bytesAt: byteIndex count: count [
	^ stream
		position: byteIndex - 1;
		next: count
]

{ #category : #accessing }
ByteArrayOnStream >> segmentFrom: start to: end [
	^ByteArraySegment on: self from: start to: end
]

{ #category : #accessing }
ByteArrayOnStream >> size [
	^ stream size
]

{ #category : #accessing }
ByteArrayOnStream >> species [
	^ByteArray
]

{ #category : #accessing }
ByteArrayOnStream >> stream: aStream [
	stream := aStream
]

{ #category : #accessing }
ByteArrayOnStream >> unsignedLongAt: byteIndex [
^(self bytesAt: byteIndex count: 4) unsignedLongAt: 1
]

{ #category : #accessing }
ByteArrayOnStream >> unsignedShortAt: byteIndex [
	^(self bytesAt: byteIndex count: 2) unsignedShortAt: 1
]
