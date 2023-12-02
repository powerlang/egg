Class {
	#name : #TCPTransmit,
	#superclass : #TCPOutputState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States-Output'
}

{ #category : #'as yet unclassified' }
TCPTransmit >> ackArrived [
	socket rescheduleRetransmitTimer
]

{ #category : #'as yet unclassified' }
TCPTransmit >> retransmit [
	self moveTo: TCPRetransmit new
]
