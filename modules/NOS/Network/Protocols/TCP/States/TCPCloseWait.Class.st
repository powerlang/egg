'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPCloseWait category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPCloseWait
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPCloseWait commentStamp: '<historical>' prior: 0!

CLOSE-WAIT - represents waiting for a connection termination request from the local user.
!

!TCPCloseWait methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	self sendFin.
	self moveTo: TCPLastACK new
! !

!TCPCloseWait methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self updateSendingWindowSize: aPacket
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPCloseWait class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPCloseWait class
	instanceVariableNames: ''!


