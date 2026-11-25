'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPSynSent category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPSynSent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPSynSent commentStamp: '<historical>' prior: 0!

SYN-SENT - represents waiting for a matching connection request after having sent a connection request.
!

!TCPSynSent methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	self reset.
	self moveTo: TCPClosed new
! !

!TCPSynSent methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
"	(aPacket ack and: [(aPacket ackSequence between: self iss and: self snext) not])
		ifTrue: [^ self reset: aPacket]."
	aPacket rst ifTrue: [self moveTo: TCPClosed new. "ConnectionReset, killtimers ... etc"].
	aPacket syn ifFalse: [^ self].
	"socket windowSize: "
	self handleAck: aPacket.
	self handleSyn: aPacket.
	self handleData: aPacket.
	aPacket ack
		ifTrue: [self sendAckImmediatly.
				self moveTo: TCPEstablished new]
		ifFalse: [self sendSynAck.
				self moveTo: TCPSynReceived new]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPSynSent class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPSynSent class
	instanceVariableNames: ''!


