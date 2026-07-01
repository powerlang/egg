'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #InternalTCPSocket category: 'SqueakNOS-Net-Protocols-TCP'!
InternalSocket subclass: #InternalTCPSocket
	instanceVariableNames: 'localPort remotePort remoteAddress mss windowSize reassembler state sendingWindowSize sequence sender lastAcknowledged finSequence delayedAck'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP'!
!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
abort
	"Close immediatly. Don't try to send any queued data."

	state abort
! !

!InternalTCPSocket methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ aPacket destination = localPort and: [(remotePort isNil or: [aPacket source = remotePort]) and: [remoteAddress isNil or: [aPacket envelope source = remoteAddress]]]
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
acknowledged: aTCPSequenceNumber
	lastAcknowledged := lastAcknowledged max: aTCPSequenceNumber
! !

!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	state close
! !

!InternalTCPSocket methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
closeAndDestroy: timeoutSeconds
	self close
! !

!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
connect
	state connect
! !

!InternalTCPSocket methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
dataAvailable
	^ reassembler dataAvailable
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
finAcknowledged
	^ lastAcknowledged >= finSequence
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstUnacknowledged
	^ lastAcknowledged + 1
! !

!InternalTCPSocket methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	windowSize := 4096.
	mss := 536. "1460."
	reassembler := TCPReassembler new.
	self state: TCPClosed new.

	sequence := TCPSequenceNumber value: 16r100000000 atRandom - 1.
	lastAcknowledged := sequence - 1.
	sendingWindowSize := 1. "whatever"
	self sender: TCPIdle new
! !

!InternalTCPSocket methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	state input: aPacket
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
isAllAcknowledged
	^ lastAcknowledged = sequence
! !

!InternalTCPSocket methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
isOtherEndClosed
	^ state isKindOf: TCPClosed
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
lastAcknowledged
	^ lastAcknowledged
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
lastError: anError
	"lastError _ anError"
! !

!InternalTCPSocket methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
left: aTCP
	super left: aTCP.
	timer := aTCP timer
! !

!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
listen
	state listen
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
localPort
	^ localPort
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
localPort: anInteger
	localPort := anInteger
! !

!InternalTCPSocket methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
maximumSegmentLifetime
	^ 60000 "1 minute"
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
mss
	^ mss
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
mss: anInteger
	mss := anInteger
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger into: aByteArray startingAt: startIndex
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."
	^ reassembler next: anInteger into: aByteArray startingAt: startIndex
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: aTCPPacket
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
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: anInteger from: aByteArray startingAt: startIndex
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
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
offeredWindow
	"Answer the 'offered' or 'maximum send' window, i.e. the range of sequence
	numbers for bytes that either have been sent but are not (yet) aknowledged
	or have not been sent but may be sent."
	^ lastAcknowledged + 1 to: lastAcknowledged + sendingWindowSize
! !

!InternalTCPSocket methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: 'TCP Socket '.
	localPort notNil ifTrue: [aStream nextPutAll: 'at '; print: localPort; space].
	remoteAddress notNil ifTrue: [aStream nextPutAll: 'to '; print: remoteAddress; nextPut: $:; print: remotePort; space].
	aStream space; nextPut: $(; nextPutAll: state name; space; nextPutAll: sender name; nextPut: $)
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
reassembler
	^ reassembler
! !

!InternalTCPSocket methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveDataTimeout: seconds into: buffer
	^ self receiveDataTimeout: seconds into: buffer startingAt: 1
! !

!InternalTCPSocket methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveDataTimeout: seconds into: buffer startingAt: index
	self waitForReadabilityTimeoutAfter: seconds * 1000.
	^ self next: buffer size - index + 1 into: buffer startingAt: index
! !

!InternalTCPSocket methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveSomeDataInto: aStringOrByteArray
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^self receiveSomeDataInto: aStringOrByteArray startingAt: 1
! !

!InternalTCPSocket methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveSomeDataInto: buffer startingAt: index
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^ self next: buffer size - index + 1 into: buffer startingAt: index
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remoteAddress
	^ remoteAddress
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remoteAddress: anInternetAddress
	remoteAddress := anInternetAddress
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePort
	^ remotePort
! !

!InternalTCPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePort: anInteger
	remotePort := anInteger
! !

!InternalTCPSocket methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
rescheduleRetransmitTimer
	self scheduleRetransmitAfter: 1000
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
reset: aPacket
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
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
retransmit
	sender retransmit
! !

!InternalTCPSocket methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
scheduleRetransmitAfter: msecs
	Transcript cr; show: 'schedule retransmit'.
	timer removeAlarm: #retransmit for: self.
	timer after: msecs send: #retransmit to: self
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendAck
	timer after: 200 send: #sendAckImmediatly to: self
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendAckImmediatly
	| tcp |
	tcp := (TCPPacket new: 0)
			ack: true;
			ackSequence: reassembler nextSequence.
	self nextPut: tcp.
	timer removeAlarm: #sendAckImmediatly for: self
! !

!InternalTCPSocket methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendData: aByteArray
	^ self nextPut: aByteArray size from: aByteArray startingAt: 1
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendFin
	| tcp |
	tcp := (TCPPacket new: 0)
			fin: true.
	self nextPut: tcp.
	finSequence := tcp sequence
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendSyn
	| tcp |
	tcp := (TCPPacket new: 0)
		syn: true.
"	tcp options: (Array with: (MSS new value: mss))."
	self nextPut: tcp
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendSynAck
	| tcp |
	tcp := (TCPPacket new: 0)
			syn: true;
			ack: true;
			ackSequence: reassembler nextSequence.
	self nextPut: tcp
! !

!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
sender
	^ sender
! !

!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
sender: aTCPOutputState
	Transcript cr; show: self printString, ' -> ', aTCPOutputState name.
	aTCPOutputState socket: self.
	sender := aTCPOutputState
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
sendingWindowSize
	^ sendingWindowSize
! !

!InternalTCPSocket methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence
	^ sequence
! !

!InternalTCPSocket methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence: aTCPSequenceNumber
	sequence := aTCPSequenceNumber
! !

!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
state
	^ state
! !

!InternalTCPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
state: aTCPState
	Transcript cr; show: self printString, ' -> ', aTCPState name.
	aTCPState socket: self.
	state := aTCPState
! !

!InternalTCPSocket methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:25'!
ttl
	^ 64
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
updateSendingWindowSize: aPacket
	sendingWindowSize := aPacket windowSize.
	sender updatedSendingWindowSize
! !

!InternalTCPSocket methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
usableWindow
	"Answer the 'usable window', i.e. the range of sequence numbers for bytes
	that may be sent for the first time. The usable window is always contained
	in the offered window."
	^ sequence + 1 to: lastAcknowledged + sendingWindowSize
! !

!InternalTCPSocket methodsFor:  'timer' stamp: 'KenD 28/Jun/2026 13:32:25'!
wait2MSL
	"(Re)schedule a delete event for 2MSL from now."
	self scheduleDetachAfter: self maximumSegmentLifetime * 2
! !

!InternalTCPSocket methodsFor:  'waiting' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForReadabilityTimeoutAfter: timeoutInMilliseconds
	"Wait for readable data, or until timeoutInMilliseconds pass, whichever comes first. -1 is special case wait for ever, also some callers pass zero"

	reassembler waitForReadabilityTimeoutAfter: timeoutInMilliseconds
! !

!InternalTCPSocket methodsFor:  'waiting' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForWritabilityTimeoutAfter: timeoutInMilliseconds
	sender waitForWritabilityTimeoutAfter: timeoutInMilliseconds
! !

!InternalTCPSocket methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:25'!
windowSize
	^ windowSize
! !

!InternalTCPSocket methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:25'!
windowSize: anInteger
	self notYetImplemented
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalTCPSocket class' category: 'SqueakNOS-Net-Protocols-TCP'!
InternalTCPSocket class
	instanceVariableNames: ''!


InternalTCPSocket initialize!

