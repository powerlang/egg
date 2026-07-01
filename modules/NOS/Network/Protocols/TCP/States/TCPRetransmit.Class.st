'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPRetransmit category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
TCPOutputState subclass: #TCPRetransmit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
!TCPRetransmit methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
ackArrived
	self moveTo: TCPTransmit new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPRetransmit class' category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
TCPRetransmit class
	instanceVariableNames: ''!


