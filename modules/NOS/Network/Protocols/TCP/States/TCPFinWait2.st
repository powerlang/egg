"
FIN-WAIT-2 - represents waiting for a connection termination request from the remote TCP.
"
Class {
	#name : #TCPFinWait2,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #protocol }
TCPFinWait2 >> input: aPacket [
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self handleData: aPacket.
	self reassembler finished ifTrue: [self moveTo: TCPTimeWait new]
]
