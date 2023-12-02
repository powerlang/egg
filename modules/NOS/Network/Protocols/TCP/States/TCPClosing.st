"
CLOSING - represents waiting for a connection termination request acknowledgment from the remote TCP.
"
Class {
	#name : #TCPClosing,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #protocol }
TCPClosing >> input: aPacket [
	aPacket rst ifTrue: [^ socket detach].
	aPacket syn ifTrue: [^ socket reset: aPacket; detach].

	self handleAck: aPacket.
	aPacket fin ifTrue: [^ self].
	self moveTo: TCPTimeWait new.
	self wait2MSL
]
