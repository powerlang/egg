Class {
	#name : #TCPPersist,
	#superclass : #TCPOutputState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States-Output'
}

{ #category : #'as yet unclassified' }
TCPPersist >> sendWindowProbe [
	^ self
]

{ #category : #'as yet unclassified' }
TCPPersist >> updatedSendingWindowSize [
	socket usableWindow size > 0 ifTrue: [self moveTo: TCPTransmit new]
]

{ #category : #'as yet unclassified' }
TCPPersist >> waitForWritabilityTimeoutAfter: timeoutInMilliseconds [
	| semaphore |
	semaphore := Semaphore new.
	self when: #transition send: #signal to: semaphore.
	semaphore waitTimeoutMSecs: timeoutInMilliseconds.
	socket sendingWindowSize > 0 ifFalse: [TimedOut new signal]
]
