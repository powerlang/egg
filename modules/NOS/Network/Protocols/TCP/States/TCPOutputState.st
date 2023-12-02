Class {
	#name : #TCPOutputState,
	#superclass : #Object,
	#instVars : [
		'socket'
	],
	#category : 'SqueakNOS-Net-Protocols-TCP-States-Output'
}

{ #category : #'as yet unclassified' }
TCPOutputState >> ackArrived [
	^ self
]

{ #category : #'as yet unclassified' }
TCPOutputState >> handleAck: aPacket [
	| prev |
	aPacket ack ifFalse: [^ self].
	prev := socket lastAcknowledged.
	socket acknowledged: aPacket ackSequence.
	prev = socket lastAcknowledged ifFalse: [self ackArrived]
]

{ #category : #'as yet unclassified' }
TCPOutputState >> moveTo: aTCPOutputState [
	socket sender: aTCPOutputState
]

{ #category : #'as yet unclassified' }
TCPOutputState >> name [
	^ self class name allButFirst: 3
]

{ #category : #'as yet unclassified' }
TCPOutputState >> retransmit [
	^ self
]

{ #category : #accessing }
TCPOutputState >> socket: aTCPSocket [
	socket := aTCPSocket
]

{ #category : #'as yet unclassified' }
TCPOutputState >> updatedSendingWindowSize [
	socket sendingWindowSize = 0 ifTrue: [self moveTo: TCPPersist new]
]

{ #category : #'as yet unclassified' }
TCPOutputState >> waitForWritabilityTimeoutAfter: timeoutInMilliseconds [
	^ self
]
