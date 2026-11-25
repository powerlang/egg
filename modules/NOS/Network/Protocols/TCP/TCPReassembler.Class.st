'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPReassembler category: 'SqueakNOS-Net-Protocols-TCP'!
Object subclass: #TCPReassembler
	instanceVariableNames: 'sequence segments stream finSequence'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP'!
!TCPReassembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: aPacket
	aPacket lastSequence <= self lastSequence ifTrue: [Transcript cr; show: 'RETRANSMISSION: ', aPacket printString, ' (reassembler seq: ', sequence printString, ')'. ^ aPacket]. "ignore retransmissions"
	segments add: aPacket.
	self flag: #todo. "handle urgent data"
	self triggerEvent: #dataArrived.
	^ aPacket
! !

!TCPReassembler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
dataAvailable
	self update.
	^ stream atEnd not
! !

!TCPReassembler methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:32:25'!
do: aBlock
	| index |
	segments isEmpty ifTrue: [^ self].
	index := sequence.
	segments do: [ :each |
		each lastSequence < index "ignore retransmissions"
			ifFalse: [(index between: each sequence and: each lastSequence)
						ifFalse: [^ self].
					aBlock value: each.
					index := each nextSequence]]
! !

!TCPReassembler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
finished
	"Answer true if a FIN and all data before it has been received."
	finSequence notNil ifTrue: [^ true].
	self update.
	finSequence notNil ifTrue: [^ true].
	self do: [ :each | each fin ifTrue: [^ true]].
	^ false
! !

!TCPReassembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	sequence := TCPSequenceNumber value: 0.
	segments := SortedCollection sortBlock: [ :a :b | a sequence <= b sequence].
	stream := ByteArray new readStream
! !

!TCPReassembler methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
isConnected
	^ true
! !

!TCPReassembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
lastSequence
	| answer |
	answer := sequence - 1.
	self do: [ :each | answer := answer max: each lastSequence].
	^ answer
! !

!TCPReassembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger into: aByteArray startingAt: startIndex
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."

	self dataAvailable ifFalse: [^ 0].
	^ (stream next: anInteger into: aByteArray startingAt: startIndex) size - startIndex + 1
! !

!TCPReassembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextAvailable
	self dataAvailable ifFalse: [^ ByteArray new].
	^ stream upToEnd
! !

!TCPReassembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextSequence
	^ self lastSequence + 1
! !

!TCPReassembler methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveDataTimeout: seconds into: buffer
	^ self receiveDataTimeout: seconds into: buffer startingAt: 1
! !

!TCPReassembler methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveDataTimeout: seconds into: buffer startingAt: index
	self waitForReadabilityTimeoutAfter: seconds * 1000.
	^ self next: buffer size - index + 1 into: buffer startingAt: index
! !

!TCPReassembler methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveSomeDataInto: aStringOrByteArray
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^self receiveSomeDataInto: aStringOrByteArray startingAt: 1
! !

!TCPReassembler methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
receiveSomeDataInto: buffer startingAt: index
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^ self next: buffer size - index + 1 into: buffer startingAt: index
! !

!TCPReassembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence: anInteger
	sequence := TCPSequenceNumber value: anInteger
! !

!TCPReassembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
update
	| aSegment |
	stream atEnd ifFalse: [^ self].
	segments isEmpty ifTrue: [^ self].
	aSegment := segments removeFirst.
	(aSegment fin and: [finSequence isNil]) ifTrue: [finSequence := aSegment lastSequence].
	stream := (aSegment rawData
				copyFrom: (sequence - aSegment sequence) asInteger + 1
				to: aSegment length) readStream.
	sequence := aSegment nextSequence
! !

!TCPReassembler methodsFor:  'waiting' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForReadabilityTimeoutAfter: timeoutInMilliseconds
	"Wait for readable data, or until timeoutInMilliseconds pass, whichever comes first. -1 is special case wait for ever, also some callers pass zero"

	| deadLine semaphore remainingMSecs |
	remainingMSecs := timeoutInMilliseconds.
	deadLine := Time millisecondClockValue + remainingMSecs.
	semaphore := Semaphore new.
	self when: #dataArrived send: #signal to: semaphore.
	[self dataAvailable]
		whileFalse: [(timeoutInMilliseconds ~~ -1 and: [(remainingMSecs := deadLine - Time millisecondClockValue) <= 0])
						ifTrue: [^ TimedOut new signal].
					semaphore waitTimeoutMSecs: remainingMSecs].
	self dataAvailable ifFalse: [TimedOut new signal]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPReassembler class' category: 'SqueakNOS-Net-Protocols-TCP'!
TCPReassembler class
	instanceVariableNames: ''!

!TCPReassembler class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ super new initialize
! !


TCPReassembler initialize!

