Class {
	#name : #TCPRetransmit,
	#superclass : #TCPOutputState,
	#category : 'SqueakNOS-Net-Protocols-TCP-States-Output'
}

{ #category : #'as yet unclassified' }
TCPRetransmit >> ackArrived [
	self moveTo: TCPTransmit new
]
