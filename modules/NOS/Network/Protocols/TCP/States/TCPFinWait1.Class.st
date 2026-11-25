'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPFinWait1 category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPFinWait1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPFinWait1 commentStamp: '<historical>' prior: 0!

FIN-WAIT-1 - represents waiting for a connection termination request from the remote TCP, or an acknowledgment of the connection termination request previously sent.
!

!TCPFinWait1 methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	self flag: #todo.
	aPacket rst ifTrue: [^ self abort: ConnectionReset].
	aPacket syn ifTrue: [^ self reset: aPacket; abort: ConnectionReset].

	self handleAck: aPacket.
	self handleData: aPacket.
	self updateSendingWindowSize: aPacket.
	self reassembler finished
		ifTrue: [socket finAcknowledged
					ifTrue: [self moveTo: TCPTimeWait new.
							"*** wake closer ***"
							self wait2MSL]
					ifFalse: [self moveTo: TCPClosing new]]
		ifFalse: [socket finAcknowledged
					ifTrue: ["*** wake closer ***"
							self moveTo: TCPFinWait2 new]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPFinWait1 class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPFinWait1 class
	instanceVariableNames: ''!


