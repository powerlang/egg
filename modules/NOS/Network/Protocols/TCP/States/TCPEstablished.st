"
ESTABLISHED - represents an open connection, data received can be delivered to the user.  The normal state for the data transfer phase of the connection.
"
Class {
	#name : #TCPEstablished,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #control }
TCPEstablished >> close [
	self sendFin.
	self moveTo: TCPFinWait1 new
]

{ #category : #protocol }
TCPEstablished >> input: aPacket [
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self handleData: aPacket.
	self updateSendingWindowSize: aPacket.
	self reassembler finished ifTrue: [self moveTo: TCPCloseWait new]
]
