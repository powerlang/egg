"
CLOSE-WAIT - represents waiting for a connection termination request from the local user.
"
Class {
	#name : #TCPCloseWait,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #control }
TCPCloseWait >> close [
	self sendFin.
	self moveTo: TCPLastACK new
]

{ #category : #protocol }
TCPCloseWait >> input: aPacket [
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self updateSendingWindowSize: aPacket
]
