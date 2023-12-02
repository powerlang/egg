"
SYN-RECEIVED - represents waiting for a confirming connection request acknowledgment after having both received and sent a connection request.
"
Class {
	#name : #TCPSynReceived,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #control }
TCPSynReceived >> close [
	self sendFin.
	self moveTo: TCPFinWait1 new
]

{ #category : #protocol }
TCPSynReceived >> input: aPacket [
	aPacket rst ifTrue: [^ self abort: ConnectionReset]. "or just detach if it was a passive open"
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self moveTo: TCPEstablished new.
	self handleData: aPacket.
	self reassembler finished ifTrue: [self moveTo: TCPCloseWait new]
]
