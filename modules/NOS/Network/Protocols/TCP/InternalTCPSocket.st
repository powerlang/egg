Class {
	#name : #InternalTCPSocket,
	#superclass : #InternalSocket,
	#instVars : [
		'localPort',
		'remotePort',
		'remoteAddress',
		'mss',
		'windowSize',
		'reassembler',
		'state',
		'sendingWindowSize',
		'sequence',
		'sender',
		'lastAcknowledged',
		'finSequence',
		'delayedAck'
	],
	#category : 'SqueakNOS-Net-Protocols-TCP'
}

{ #category : #control }
InternalTCPSocket >> abort [
	"Close immediatly. Don't try to send any queued data."

	state abort
]

{ #category : #flow }
InternalTCPSocket >> accepts: aPacket [
	^ aPacket destination = localPort and: [(remotePort isNil or: [aPacket source = remotePort]) and: [remoteAddress isNil or: [aPacket envelope source = remoteAddress]]]
]

{ #category : #protocol }
InternalTCPSocket >> acknowledged: aTCPSequenceNumber [
	lastAcknowledged := lastAcknowledged max: aTCPSequenceNumber
]

{ #category : #control }
InternalTCPSocket >> close [
	state close
]

{ #category : #compatibility }
InternalTCPSocket >> closeAndDestroy: timeoutSeconds [
	self close
]

{ #category : #control }
InternalTCPSocket >> connect [
	state connect
]

{ #category : #testing }
InternalTCPSocket >> dataAvailable [
	^ reassembler dataAvailable
]

{ #category : #protocol }
InternalTCPSocket >> finAcknowledged [
	^ lastAcknowledged >= finSequence
]

{ #category : #protocol }
InternalTCPSocket >> firstUnacknowledged [
	^ lastAcknowledged + 1
]

{ #category : #initialization }
InternalTCPSocket >> initialize [
	super initialize.
	windowSize := 4096.
	mss := 536. "1460."
	reassembler := TCPReassembler new.
	self state: TCPClosed new.

	sequence := TCPSequenceNumber value: 16r100000000 atRandom - 1.
	lastAcknowledged := sequence - 1.
	sendingWindowSize := 1. "whatever"
	self sender: TCPIdle new
]

{ #category : #flow }
InternalTCPSocket >> input: aPacket [
	state input: aPacket
]

{ #category : #protocol }
InternalTCPSocket >> isAllAcknowledged [
	^ lastAcknowledged = sequence
]

{ #category : #compatibility }
InternalTCPSocket >> isOtherEndClosed [
	^ state isKindOf: TCPClosed
]

{ #category : #protocol }
InternalTCPSocket >> lastAcknowledged [
	^ lastAcknowledged
]

{ #category : #protocol }
InternalTCPSocket >> lastError: anError [
	"lastError _ anError"
]

{ #category : #initialization }
InternalTCPSocket >> left: aTCP [
	super left: aTCP.
	timer := aTCP timer
]

{ #category : #control }
InternalTCPSocket >> listen [
	state listen
]

{ #category : #accessing }
InternalTCPSocket >> localPort [
	^ localPort
]

{ #category : #accessing }
InternalTCPSocket >> localPort: anInteger [
	localPort := anInteger
]

{ #category : #timer }
InternalTCPSocket >> maximumSegmentLifetime [
	^ 60000 "1 minute"
]

{ #category : #protocol }
InternalTCPSocket >> mss [
	^ mss
]

{ #category : #protocol }
InternalTCPSocket >> mss: anInteger [
	mss := anInteger
]

{ #category : #accessing }
InternalTCPSocket >> next: anInteger into: aByteArray startingAt: startIndex [
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."
	^ reassembler next: anInteger into: aByteArray startingAt: startIndex
]

{ #category : #accessing }
InternalTCPSocket >> nextPut: aTCPPacket [
	| ip |
	aTCPPacket
		source: self localPort;
		destination: self remotePort;
		windowSize: self windowSize;
		sequence: self sequence.
	ip := IPPacket with: aTCPPacket.
	ip destination: self remoteAddress; ttl: self ttl.
	self << ip.
	self sequence: aTCPPacket nextSequence
]

{ #category : #accessing }
InternalTCPSocket >> nextPut: anInteger from: aByteArray startingAt: startIndex [
	"Write the next anInteger elements in aByteArray, starting at startIndex. Answer the number of bytes actually written."

	| tcp |
	self flag: #todo. "this should be implemented in tcp states"
	tcp := TCPPacket new: anInteger.
	tcp replaceFrom: tcp headerSize + 1 to: tcp size with: aByteArray asByteArray startingAt: startIndex.
	tcp psh: true; source: self localPort; destination: self remotePort.
	tcp ack: true; ackSequence: reassembler nextSequence.
	timer removeAlarm: #sendAckImmediatly for: self.
	self nextPut: tcp.
	^ anInteger
]

{ #category : #protocol }
InternalTCPSocket >> offeredWindow [
	"Answer the 'offered' or 'maximum send' window, i.e. the range of sequence
	numbers for bytes that either have been sent but are not (yet) aknowledged
	or have not been sent but may be sent."
	^ lastAcknowledged + 1 to: lastAcknowledged + sendingWindowSize
]

{ #category : #printing }
InternalTCPSocket >> printOn: aStream [
	aStream nextPutAll: 'TCP Socket '.
	localPort notNil ifTrue: [aStream nextPutAll: 'at '; print: localPort; space].
	remoteAddress notNil ifTrue: [aStream nextPutAll: 'to '; print: remoteAddress; nextPut: $:; print: remotePort; space].
	aStream space; nextPut: $(; nextPutAll: state name; space; nextPutAll: sender name; nextPut: $)
]

{ #category : #protocol }
InternalTCPSocket >> reassembler [
	^ reassembler
]

{ #category : #compatibility }
InternalTCPSocket >> receiveDataTimeout: seconds into: buffer [
	^ self receiveDataTimeout: seconds into: buffer startingAt: 1
]

{ #category : #compatibility }
InternalTCPSocket >> receiveDataTimeout: seconds into: buffer startingAt: index [
	self waitForReadabilityTimeoutAfter: seconds * 1000.
	^ self next: buffer size - index + 1 into: buffer startingAt: index
]

{ #category : #compatibility }
InternalTCPSocket >> receiveSomeDataInto: aStringOrByteArray [
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^self receiveSomeDataInto: aStringOrByteArray startingAt: 1
]

{ #category : #compatibility }
InternalTCPSocket >> receiveSomeDataInto: buffer startingAt: index [
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^ self next: buffer size - index + 1 into: buffer startingAt: index
]

{ #category : #accessing }
InternalTCPSocket >> remoteAddress [
	^ remoteAddress
]

{ #category : #accessing }
InternalTCPSocket >> remoteAddress: anInternetAddress [
	remoteAddress := anInternetAddress
]

{ #category : #accessing }
InternalTCPSocket >> remotePort [
	^ remotePort
]

{ #category : #accessing }
InternalTCPSocket >> remotePort: anInteger [
	remotePort := anInteger
]

{ #category : #timer }
InternalTCPSocket >> rescheduleRetransmitTimer [
	self scheduleRetransmitAfter: 1000
]

{ #category : #protocol }
InternalTCPSocket >> reset: aPacket [
	"Send a RESET in response to aPacket."
	| tcp ip |
	aPacket rst ifTrue: [^ self].
	tcp := (TCPPacket new: 0)
		source: aPacket destination;
		destination: aPacket source;
		rst: true.
	aPacket ack
		ifTrue: [tcp sequence: aPacket ackSequence]
		ifFalse: [tcp ackSequence: aPacket nextSequence; ack: true].
	(ip := IPPacket with: tcp)
		destination: aPacket envelope source.
	self << ip
]

{ #category : #protocol }
InternalTCPSocket >> retransmit [
	sender retransmit
]

{ #category : #timer }
InternalTCPSocket >> scheduleRetransmitAfter: msecs [
	Transcript cr; show: 'schedule retransmit'.
	timer removeAlarm: #retransmit for: self.
	timer after: msecs send: #retransmit to: self
]

{ #category : #protocol }
InternalTCPSocket >> sendAck [
	timer after: 200 send: #sendAckImmediatly to: self
]

{ #category : #protocol }
InternalTCPSocket >> sendAckImmediatly [
	| tcp |
	tcp := (TCPPacket new: 0)
			ack: true;
			ackSequence: reassembler nextSequence.
	self nextPut: tcp.
	timer removeAlarm: #sendAckImmediatly for: self
]

{ #category : #compatibility }
InternalTCPSocket >> sendData: aByteArray [
	^ self nextPut: aByteArray size from: aByteArray startingAt: 1
]

{ #category : #protocol }
InternalTCPSocket >> sendFin [
	| tcp |
	tcp := (TCPPacket new: 0)
			fin: true.
	self nextPut: tcp.
	finSequence := tcp sequence
]

{ #category : #protocol }
InternalTCPSocket >> sendSyn [
	| tcp |
	tcp := (TCPPacket new: 0)
		syn: true.
"	tcp options: (Array with: (MSS new value: mss))."
	self nextPut: tcp
]

{ #category : #protocol }
InternalTCPSocket >> sendSynAck [
	| tcp |
	tcp := (TCPPacket new: 0)
			syn: true;
			ack: true;
			ackSequence: reassembler nextSequence.
	self nextPut: tcp
]

{ #category : #control }
InternalTCPSocket >> sender [
	^ sender
]

{ #category : #control }
InternalTCPSocket >> sender: aTCPOutputState [
	Transcript cr; show: self printString, ' -> ', aTCPOutputState name.
	aTCPOutputState socket: self.
	sender := aTCPOutputState
]

{ #category : #protocol }
InternalTCPSocket >> sendingWindowSize [
	^ sendingWindowSize
]

{ #category : #configuration }
InternalTCPSocket >> sequence [
	^ sequence
]

{ #category : #configuration }
InternalTCPSocket >> sequence: aTCPSequenceNumber [
	sequence := aTCPSequenceNumber
]

{ #category : #control }
InternalTCPSocket >> state [
	^ state
]

{ #category : #control }
InternalTCPSocket >> state: aTCPState [
	Transcript cr; show: self printString, ' -> ', aTCPState name.
	aTCPState socket: self.
	state := aTCPState
]

{ #category : #configuration }
InternalTCPSocket >> ttl [
	^ 64
]

{ #category : #protocol }
InternalTCPSocket >> updateSendingWindowSize: aPacket [
	sendingWindowSize := aPacket windowSize.
	sender updatedSendingWindowSize
]

{ #category : #protocol }
InternalTCPSocket >> usableWindow [
	"Answer the 'usable window', i.e. the range of sequence numbers for bytes
	that may be sent for the first time. The usable window is always contained
	in the offered window."
	^ sequence + 1 to: lastAcknowledged + sendingWindowSize
]

{ #category : #timer }
InternalTCPSocket >> wait2MSL [
	"(Re)schedule a delete event for 2MSL from now."
	self scheduleDetachAfter: self maximumSegmentLifetime * 2
]

{ #category : #waiting }
InternalTCPSocket >> waitForReadabilityTimeoutAfter: timeoutInMilliseconds [
	"Wait for readable data, or until timeoutInMilliseconds pass, whichever comes first. -1 is special case wait for ever, also some callers pass zero"

	reassembler waitForReadabilityTimeoutAfter: timeoutInMilliseconds
]

{ #category : #waiting }
InternalTCPSocket >> waitForWritabilityTimeoutAfter: timeoutInMilliseconds [
	sender waitForWritabilityTimeoutAfter: timeoutInMilliseconds
]

{ #category : #configuration }
InternalTCPSocket >> windowSize [
	^ windowSize
]

{ #category : #configuration }
InternalTCPSocket >> windowSize: anInteger [
	self notYetImplemented
]
