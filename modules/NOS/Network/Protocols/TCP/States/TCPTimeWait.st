"
TIME-WAIT - represents waiting for enough time to pass to be sure the remote TCP received the acknowledgment of its connection termination request.
"
Class {
	#name : #TCPTimeWait,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #protocol }
TCPTimeWait >> input: aPacket [
	aPacket rst ifTrue: [^ socket detach].
	aPacket syn ifTrue: [^ socket reset: aPacket; detach].
	self handleAck: aPacket.
	self handleData: aPacket.
	self wait2MSL
]
