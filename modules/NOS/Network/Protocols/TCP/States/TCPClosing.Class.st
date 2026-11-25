'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPClosing category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPClosing commentStamp: '<historical>' prior: 0!

CLOSING - represents waiting for a connection termination request acknowledgment from the remote TCP.
!

!TCPClosing methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	aPacket rst ifTrue: [^ socket detach].
	aPacket syn ifTrue: [^ socket reset: aPacket; detach].

	self handleAck: aPacket.
	aPacket fin ifTrue: [^ self].
	self moveTo: TCPTimeWait new.
	self wait2MSL
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPClosing class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPClosing class
	instanceVariableNames: ''!


