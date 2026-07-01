'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPTransmit category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
TCPOutputState subclass: #TCPTransmit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
!TCPTransmit methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
ackArrived
	socket rescheduleRetransmitTimer
! !

!TCPTransmit methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
retransmit
	self moveTo: TCPRetransmit new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPTransmit class' category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
TCPTransmit class
	instanceVariableNames: ''!


