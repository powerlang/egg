'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPFinWait2 category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPFinWait2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPFinWait2 commentStamp: '<historical>' prior: 0!

FIN-WAIT-2 - represents waiting for a connection termination request from the remote TCP.
!

!TCPFinWait2 methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self handleData: aPacket.
	self reassembler finished ifTrue: [self moveTo: TCPTimeWait new]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPFinWait2 class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPFinWait2 class
	instanceVariableNames: ''!


