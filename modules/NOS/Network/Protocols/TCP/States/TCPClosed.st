"
CLOSED - represents no connection state at all.
"
Class {
	#name : #TCPClosed,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #control }
TCPClosed >> connect [
	self sendSyn.
	self moveTo: TCPSynSent new
]

{ #category : #protocol }
TCPClosed >> input: aPacket [
	socket reset: aPacket
]

{ #category : #control }
TCPClosed >> listen [
	self moveTo: TCPListen new
]
