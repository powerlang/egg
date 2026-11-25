'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #InternalRawSocket category: 'SqueakNOS-Net-Conduits'!
InternalSocket subclass: #InternalRawSocket
	instanceVariableNames: 'inputQ inputStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Conduits'!
!InternalRawSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
dataAvailable
	"Answer whether there is data available for reading."
	^ inputStream atEnd not or: [inputQ isEmpty not]
! !

!InternalRawSocket methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	inputStream := '' readStream.
	inputQ := SharedQueue new
! !

!InternalRawSocket methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	inputQ nextPut: aPacket
! !

!InternalRawSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next
	^ inputQ next
! !

!InternalRawSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger into: aByteArray startingAt: startIndex
	"Read the next anInteger bytes into aByteArray, starting at startIndex. Answer the number of bytes actually read."

	self dataAvailable ifFalse: [^ 0].
	inputStream atEnd ifTrue: [inputStream _ self next rawDataStream].
	^ (inputStream next: anInteger into: aByteArray startingAt: startIndex) size
! !

!InternalRawSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: aPacket
	self << aPacket.
	^ aPacket
! !

!InternalRawSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextTimeoutMSecs: milliseconds
	^ inputQ nextTimeoutMSecs: milliseconds
! !

!InternalRawSocket methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitForReadabilityTimeoutAfter: timeoutInMilliseconds
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
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalRawSocket class' category: 'SqueakNOS-Net-Conduits'!
InternalRawSocket class
	instanceVariableNames: ''!


InternalRawSocket initialize!

