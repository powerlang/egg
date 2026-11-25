'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPListen category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPListen
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPListen commentStamp: '<historical>' prior: 0!

LISTEN - represents waiting for a connection request from any remote TCP and port.
!

!TCPListen methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	self moveTo: TCPClosed new
! !

!TCPListen methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
connect
	self sendSyn.
	self moveTo: TCPSynSent new
! !

!TCPListen methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	self flag: #todo.
	aPacket rst ifTrue: [^ self].
	(aPacket ack or: [aPacket syn]) ifFalse: [socket reset: aPacket. ^ self].
	aPacket syn ifFalse: [^ self].
	socket remotePort isNil ifTrue: [socket remotePort: aPacket source].
	socket remoteAddress isNil ifTrue: [socket remoteAddress: aPacket envelope source].
	self handleSyn: aPacket.
	self sendSynAck.
	self moveTo: TCPSynReceived new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPListen class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPListen class
	instanceVariableNames: ''!


