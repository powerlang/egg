'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #CircularBuffer category: 'SqueakNOS-Net-Support'!
SequenceableCollection subclass: #CircularBuffer
	instanceVariableNames: 'buffer head tally'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!CircularBuffer methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: anObject
	tally < buffer size ifFalse: [^ self errorOutOfBounds].
	buffer at: head + tally - 1 \\ buffer size + 1 put: anObject.
	tally := tally + 1.
	^ anObject
! !

!CircularBuffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	(anInteger > 0 and: [anInteger <= tally]) ifFalse: [^ self errorOutOfBounds].
	^ buffer at: head + anInteger - 2 \\ buffer size + 1
! !

!CircularBuffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
capacity
	^ buffer size - self size
! !

!CircularBuffer methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize: capacity
	buffer := ByteArray new: capacity.
	head := 1.
	tally := 0
! !

!CircularBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next
	| answer |
	tally > 0 ifFalse: [^ self errorOutOfBounds].
	answer := self first.
	tally := tally - 1.
	head := head \\ buffer size + 1.
	^ answer
! !

!CircularBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: anObject
	tally < buffer size ifFalse: [^ self errorOutOfBounds].
	buffer at: head + tally - 1 \\ buffer size + 1 put: anObject.
	tally := tally + 1.
	^ anObject
! !

!CircularBuffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPutAll: aCollection
	aCollection do: [ :each | self nextPut: each]
! !

!CircularBuffer methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeFirst
	| answer |
	tally > 0 ifFalse: [^ self errorOutOfBounds].
	answer := self first.
	tally := tally - 1.
	head := head \\ buffer size + 1.
	^ answer
! !

!CircularBuffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ tally
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CircularBuffer class' category: 'SqueakNOS-Net-Support'!
CircularBuffer class
	instanceVariableNames: ''!

!CircularBuffer class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ self new: 512
! !

!CircularBuffer class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
new: anInteger
	^ super new initialize: anInteger
! !


