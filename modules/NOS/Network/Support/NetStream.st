Class {
	#name : #NetStream,
	#superclass : #SocketStream,
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #'as yet unclassified' }
NetStream >> dataAvailable [
	^ self isDataAvailable
]

{ #category : #'as yet unclassified' }
NetStream >> next: anInteger timeoutAfter: msecs [
	self timeout: msecs // 1000.
	^self next: anInteger
]

{ #category : #'as yet unclassified' }
NetStream >> waitForReadabilityTimeoutAfter: timeoutInMilliseconds [
	^ socket waitForReadabilityTimeoutAfter: timeoutInMilliseconds
]
