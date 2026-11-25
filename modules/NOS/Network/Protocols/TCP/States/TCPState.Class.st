'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPState category: 'SqueakNOS-Net-Protocols-TCP-States'!
Object subclass: #TCPState
	instanceVariableNames: 'socket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP-States'!
!TCPState methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
abort: anError
	"Abort the connection with anError."
	socket lastError: anError; detach
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleAck: aPacket
	socket sender handleAck: aPacket
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleData: aPacket
	| previousLastSequence |
	previousLastSequence := self reassembler lastSequence.
	self reassembler add: aPacket.
	self reassembler lastSequence > previousLastSequence
		ifTrue: [self sendAck]
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleSyn: aPacket
	self reassembler sequence: aPacket nextSequence.
	socket mss: (socket mss min: (aPacket mss ifNil: [536])).
	self updateSendingWindowSize: aPacket "is this right ???"
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	self subclassResponsibility
! !

!TCPState methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
moveTo: aTCPState
	socket state: aTCPState
! !

!TCPState methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name
	^ self class name allButFirst: 3
! !

!TCPState methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reassembler
	^ socket reassembler
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
reset: aPacket
	socket reset: aPacket
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendAck
	socket sendAck
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendAckImmediatly
	socket sendAckImmediatly
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendFin
	socket sendFin
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendSyn
	socket sendSyn
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendSynAck
	socket sendSynAck
! !

!TCPState methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
socket: aTCPSocket
	socket := aTCPSocket
! !

!TCPState methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
updateSendingWindowSize: aPacket
	socket updateSendingWindowSize: aPacket
! !

!TCPState methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
wait2MSL
	"(Re)schedule a delete event for 2MSL from now."
	socket wait2MSL
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPState class' category: 'SqueakNOS-Net-Protocols-TCP-States'!
TCPState class
	instanceVariableNames: ''!


