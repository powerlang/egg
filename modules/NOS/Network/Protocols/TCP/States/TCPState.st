Class {
	#name : #TCPState,
	#superclass : #Object,
	#instVars : [
		'socket'
	],
	#category : 'SqueakNOS-Net-Protocols-TCP-States'
}

{ #category : #control }
TCPState >> abort: anError [
	"Abort the connection with anError."
	socket lastError: anError; detach
]

{ #category : #protocol }
TCPState >> handleAck: aPacket [
	socket sender handleAck: aPacket
]

{ #category : #protocol }
TCPState >> handleData: aPacket [
	| previousLastSequence |
	previousLastSequence := self reassembler lastSequence.
	self reassembler add: aPacket.
	self reassembler lastSequence > previousLastSequence
		ifTrue: [self sendAck]
]

{ #category : #protocol }
TCPState >> handleSyn: aPacket [
	self reassembler sequence: aPacket nextSequence.
	socket mss: (socket mss min: (aPacket mss ifNil: [536])).
	self updateSendingWindowSize: aPacket "is this right ???"
]

{ #category : #protocol }
TCPState >> input: aPacket [
	self subclassResponsibility
]

{ #category : #accessing }
TCPState >> moveTo: aTCPState [
	socket state: aTCPState
]

{ #category : #accessing }
TCPState >> name [
	^ self class name allButFirst: 3
]

{ #category : #accessing }
TCPState >> reassembler [
	^ socket reassembler
]

{ #category : #protocol }
TCPState >> reset: aPacket [
	socket reset: aPacket
]

{ #category : #protocol }
TCPState >> sendAck [
	socket sendAck
]

{ #category : #protocol }
TCPState >> sendAckImmediatly [
	socket sendAckImmediatly
]

{ #category : #protocol }
TCPState >> sendFin [
	socket sendFin
]

{ #category : #protocol }
TCPState >> sendSyn [
	socket sendSyn
]

{ #category : #protocol }
TCPState >> sendSynAck [
	socket sendSynAck
]

{ #category : #accessing }
TCPState >> socket: aTCPSocket [
	socket := aTCPSocket
]

{ #category : #protocol }
TCPState >> updateSendingWindowSize: aPacket [
	socket updateSendingWindowSize: aPacket
]

{ #category : #control }
TCPState >> wait2MSL [
	"(Re)schedule a delete event for 2MSL from now."
	socket wait2MSL
]
