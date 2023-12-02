"
LISTEN - represents waiting for a connection request from any remote TCP and port.
"
Class {
	#name : #TCPListen,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #control }
TCPListen >> close [
	self moveTo: TCPClosed new
]

{ #category : #control }
TCPListen >> connect [
	self sendSyn.
	self moveTo: TCPSynSent new
]

{ #category : #protocol }
TCPListen >> input: aPacket [
	self flag: #todo.
	aPacket rst ifTrue: [^ self].
	(aPacket ack or: [aPacket syn]) ifFalse: [socket reset: aPacket. ^ self].
	aPacket syn ifFalse: [^ self].
	socket remotePort isNil ifTrue: [socket remotePort: aPacket source].
	socket remoteAddress isNil ifTrue: [socket remoteAddress: aPacket envelope source].
	self handleSyn: aPacket.
	self sendSynAck.
	self moveTo: TCPSynReceived new
]
