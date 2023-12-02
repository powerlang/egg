Class {
	#name : #InternalRawSocket,
	#superclass : #InternalSocket,
	#instVars : [
		'inputQ',
		'inputStream'
	],
	#category : 'SqueakNOS-Net-Conduits'
}

{ #category : #accessing }
InternalRawSocket >> dataAvailable [
	"Answer whether there is data available for reading."
	^ inputStream atEnd not or: [inputQ isEmpty not]
]

{ #category : #initialization }
InternalRawSocket >> initialize [
	super initialize.
	inputStream := '' readStream.
	inputQ := SharedQueue new
]

{ #category : #flow }
InternalRawSocket >> input: aPacket [
	inputQ nextPut: aPacket
]

{ #category : #accessing }
InternalRawSocket >> next [
	^ inputQ next
]

{ #category : #accessing }
InternalRawSocket >> next: anInteger into: aByteArray startingAt: startIndex [
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."

	self dataAvailable ifFalse: [^ 0].
	inputStream atEnd ifTrue: [inputStream _ self next rawDataStream].
	^ (inputStream next: anInteger into: aByteArray startingAt: startIndex) size
]

{ #category : #accessing }
InternalRawSocket >> nextPut: aPacket [
	self << aPacket.
	^ aPacket
]

{ #category : #accessing }
InternalRawSocket >> nextTimeoutMSecs: milliseconds [
	^ inputQ nextTimeoutMSecs: milliseconds
]

{ #category : #flow }
InternalRawSocket >> waitForReadabilityTimeoutAfter: timeoutInMilliseconds [
	"Wait for readable data, or until timeoutInMilliseconds pass, whichever comes first. -1 is special case wait for ever, also some callers pass zero"

	| deadLine aPacket |
	timeoutInMilliseconds < 0
		ifTrue: [self dataAvailable ifTrue: [^ self].
				inputStream := inputQ next rawDataStream.
				^ self].

	deadLine := Time millisecondClockValue + timeoutInMilliseconds.
	timedOut := false.
	self dataAvailable ifTrue: [^ self].
	aPacket := self nextTimeoutMSecs: timeoutInMilliseconds.
	aPacket isNil ifFalse: [inputStream := aPacket rawDataStream].
	self dataAvailable
		ifFalse: [(deadLine - Time millisecondClockValue - 1) < 0 ifTrue: [timedOut := true].
				TimedOut new signal]
]
