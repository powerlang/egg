'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPSynReceived category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPSynReceived
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPSynReceived commentStamp: '<historical>' prior: 0!

SYN-RECEIVED - represents waiting for a confirming connection request acknowledgment after having both received and sent a connection request.
!

!TCPSynReceived methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	self sendFin.
	self moveTo: TCPFinWait1 new
! !

!TCPSynReceived methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	aPacket rst ifTrue: [^ self abort: ConnectionReset]. "or just detach if it was a passive open"
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self moveTo: TCPEstablished new.
	self handleData: aPacket.
	self reassembler finished ifTrue: [self moveTo: TCPCloseWait new]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPSynReceived class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPSynReceived class
	instanceVariableNames: ''!


