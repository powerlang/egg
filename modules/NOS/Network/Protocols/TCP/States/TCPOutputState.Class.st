'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPOutputState category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
Object subclass: #TCPOutputState
	instanceVariableNames: 'socket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
!TCPOutputState methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
ackArrived
	^ self
! !

!TCPOutputState methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleAck: aPacket
	| prev |
	aPacket ack ifFalse: [^ self].
	prev := socket lastAcknowledged.
	socket acknowledged: aPacket ackSequence.
	prev = socket lastAcknowledged ifFalse: [self ackArrived]
! !

!TCPOutputState methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
moveTo: aTCPOutputState
	socket sender: aTCPOutputState
! !

!TCPOutputState methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
name
	^ self class name allButFirst: 3
! !

!TCPOutputState methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
retransmit
	^ self
! !

!TCPOutputState methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
socket: aTCPSocket
	socket := aTCPSocket
! !

!TCPOutputState methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
updatedSendingWindowSize
	socket sendingWindowSize = 0 ifTrue: [self moveTo: TCPPersist new]
! !

!TCPOutputState methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForWritabilityTimeoutAfter: timeoutInMilliseconds
	^ self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPOutputState class' category: 'SqueakNOS-Net-Protocols-TCP-States-Output'!
TCPOutputState class
	instanceVariableNames: ''!


