'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPTimeWait category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState subclass: #TCPTimeWait
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPTimeWait commentStamp: '<historical>' prior: 0!

TIME-WAIT - represents waiting for enough time to pass to be sure the remote TCP received the acknowledgment of its connection termination request.
!

!TCPTimeWait methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	aPacket rst ifTrue: [^ socket detach].
	aPacket syn ifTrue: [^ socket reset: aPacket; detach].
	self handleAck: aPacket.
	self handleData: aPacket.
	self wait2MSL
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPTimeWait class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPTimeWait class
	instanceVariableNames: ''!


