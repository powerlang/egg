"
LAST-ACK - represents waiting for an acknowledgment of the connection termination request previously sent to the remote TCP (which includes an acknowledgment of its connection termination request).
"
Class {
	#name : #TCPLastACK,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #protocol }
TCPLastACK >> input: aPacket [
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.

	self flag: #todo.

	socket finAcknowledged
		ifTrue: [self moveTo: TCPClosed new.
				socket detach]
]
