'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPClosed category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPClosed commentStamp: '<historical>' prior: 0!

CLOSED - represents no connection state at all.
!

!TCPClosed methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
connect
	self sendSyn.
	self moveTo: TCPSynSent new
! !

!TCPClosed methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	socket reset: aPacket
! !

!TCPClosed methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
listen
	self moveTo: TCPListen new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPClosed class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPClosed class
	instanceVariableNames: ''!


