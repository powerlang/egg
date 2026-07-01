'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPMemoizedParser category: #Parsers!
PPDelegateParser subclass: #PPMemoizedParser
	instanceVariableNames: 'stream buffer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPMemoizedParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPMemoizedParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
memoized
	"Ther is no point in memoizing more than once."

	^ self
! !

!PPMemoizedParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| memento |
	stream == aStream ifFalse: [self reset: aStream].
	memento := (buffer at: stream position + 1)
		ifNil: [buffer at: stream position + 1 put: PPMemento new].
	memento position isNil
		ifTrue: [
			memento
				result: (stream size - stream position + 2 < memento count
					ifTrue: [PPFailure message: 'overflow' from: stream]
					ifFalse: [
						memento increment.
						parser parseOn: stream]).
			memento position: stream position]
		ifFalse: [stream position: memento position].
	^memento result
! !

!PPMemoizedParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	self printSmalltalkReceiverOn: rtf.
	parser nextPutAll: ' memoized'
! !

!PPMemoizedParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset: aStream
	stream := aStream.
	buffer := Array new: aStream size + 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPMemoizedParser class' category: #Parsers!
PPMemoizedParser class
	instanceVariableNames: ''!


