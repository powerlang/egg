Class {
	#name : #TCPReassembler,
	#superclass : #Object,
	#instVars : [
		'sequence',
		'segments',
		'stream',
		'finSequence'
	],
	#category : 'SqueakNOS-Net-Protocols-TCP'
}

{ #category : #'as yet unclassified' }
TCPReassembler class >> new [
	^ super new initialize
]

{ #category : #accessing }
TCPReassembler >> add: aPacket [
	aPacket lastSequence <= self lastSequence ifTrue: [Transcript cr; show: 'RETRANSMISSION: ', aPacket printString, ' (reassembler seq: ', sequence printString, ')'. ^ aPacket]. "ignore retransmissions"
	segments add: aPacket.
	self flag: #todo. "handle urgent data"
	self triggerEvent: #dataArrived.
	^ aPacket
]

{ #category : #testing }
TCPReassembler >> dataAvailable [
	self update.
	^ stream atEnd not
]

{ #category : #enumerating }
TCPReassembler >> do: aBlock [
	| index |
	segments isEmpty ifTrue: [^ self].
	index := sequence.
	segments do: [ :each |
		each lastSequence < index "ignore retransmissions"
			ifFalse: [(index between: each sequence and: each lastSequence)
						ifFalse: [^ self].
					aBlock value: each.
					index := each nextSequence]]
]

{ #category : #testing }
TCPReassembler >> finished [
	"Answer true if a FIN and all data before it has been received."
	finSequence notNil ifTrue: [^ true].
	self update.
	finSequence notNil ifTrue: [^ true].
	self do: [ :each | each fin ifTrue: [^ true]].
	^ false
]

{ #category : #initialization }
TCPReassembler >> initialize [
	sequence := TCPSequenceNumber value: 0.
	segments := SortedCollection sortBlock: [ :a :b | a sequence <= b sequence].
	stream := ByteArray new readStream
]

{ #category : #compatibility }
TCPReassembler >> isConnected [
	^ true
]

{ #category : #accessing }
TCPReassembler >> lastSequence [
	| answer |
	answer := sequence - 1.
	self do: [ :each | answer := answer max: each lastSequence].
	^ answer
]

{ #category : #accessing }
TCPReassembler >> next: anInteger into: aByteArray startingAt: startIndex [
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."

	self dataAvailable ifFalse: [^ 0].
	^ (stream next: anInteger into: aByteArray startingAt: startIndex) size - startIndex + 1
]

{ #category : #accessing }
TCPReassembler >> nextAvailable [
	self dataAvailable ifFalse: [^ ByteArray new].
	^ stream upToEnd
]

{ #category : #accessing }
TCPReassembler >> nextSequence [
	^ self lastSequence + 1
]

{ #category : #compatibility }
TCPReassembler >> receiveDataTimeout: seconds into: buffer [
	^ self receiveDataTimeout: seconds into: buffer startingAt: 1
]

{ #category : #compatibility }
TCPReassembler >> receiveDataTimeout: seconds into: buffer startingAt: index [
	self waitForReadabilityTimeoutAfter: seconds * 1000.
	^ self next: buffer size - index + 1 into: buffer startingAt: index
]

{ #category : #compatibility }
TCPReassembler >> receiveSomeDataInto: aStringOrByteArray [
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^self receiveSomeDataInto: aStringOrByteArray startingAt: 1
]

{ #category : #compatibility }
TCPReassembler >> receiveSomeDataInto: buffer startingAt: index [
	"Receive data into the given buffer and return the number of bytes received. Note the given buffer may be only partially filled by the received data."

	^ self next: buffer size - index + 1 into: buffer startingAt: index
]

{ #category : #accessing }
TCPReassembler >> sequence: anInteger [
	sequence := TCPSequenceNumber value: anInteger
]

{ #category : #private }
TCPReassembler >> update [
	| aSegment |
	stream atEnd ifFalse: [^ self].
	segments isEmpty ifTrue: [^ self].
	aSegment := segments removeFirst.
	(aSegment fin and: [finSequence isNil]) ifTrue: [finSequence := aSegment lastSequence].
	stream := (aSegment rawData
				copyFrom: (sequence - aSegment sequence) asInteger + 1
				to: aSegment length) readStream.
	sequence := aSegment nextSequence
]

{ #category : #waiting }
TCPReassembler >> waitForReadabilityTimeoutAfter: timeoutInMilliseconds [
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
]
