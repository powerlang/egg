"
FIN-WAIT-1 - represents waiting for a connection termination request from the remote TCP, or an acknowledgment of the connection termination request previously sent.
"
Class {
	#name : #TCPFinWait1,
	#superclass : #TCPState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #protocol }
TCPFinWait1 >> input: aPacket [
	self flag: #todo.
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self handleData: aPacket.
	self updateSendingWindowSize: aPacket.
	self reassembler finished
		ifTrue: [socket finAcknowledged
					ifTrue: [self moveTo: TCPTimeWait new.
							"*** wake closer ***"
							self wait2MSL]
					ifFalse: [self moveTo: TCPClosing new]]
		ifFalse: [socket finAcknowledged
					ifTrue: ["*** wake closer ***"
							self moveTo: TCPFinWait2 new]]
]
