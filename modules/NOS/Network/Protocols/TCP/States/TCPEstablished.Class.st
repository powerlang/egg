'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPEstablished category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPEstablished
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPEstablished commentStamp: '<historical>' prior: 0!

ESTABLISHED - represents an open connection, data received can be delivered to the user.  The normal state for the data transfer phase of the connection.
!

!TCPEstablished methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	self sendFin.
	self moveTo: TCPFinWait1 new
! !

!TCPEstablished methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self handleData: aPacket.
	self updateSendingWindowSize: aPacket.
	self reassembler finished ifTrue: [self moveTo: TCPCloseWait new]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPEstablished class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPEstablished class
	instanceVariableNames: ''!


