'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPLastACK category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPLastACK
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPLastACK commentStamp: '<historical>' prior: 0!

LAST-ACK - represents waiting for an acknowledgment of the connection termination request previously sent to the remote TCP (which includes an acknowledgment of its connection termination request).
!

!TCPLastACK methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.

	self flag: #todo.

	socket finAcknowledged
		ifTrue: [self moveTo: TCPClosed new.
				socket detach]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPLastACK class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPLastACK class
	instanceVariableNames: ''!


