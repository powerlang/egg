'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TonelReader category: #Tonel!
Object subclass: #TonelReader
	instanceVariableNames: 'class methods stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tonel'!
!TonelReader commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!TonelReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
definition
	^class
! !

!TonelReader methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	class := OrderedDictionary new.
	methods := OrderedCollection new
! !

!TonelReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
methods
	^methods
! !

!TonelReader methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextBlock
	| nested char start eol skipNext |
	nested := 1.
	skipNext := false.
	start := stream skipLine; position.
	[nested > 0] whileTrue: [
		stream atEnd ifTrue: [^self error: 'unterminated method body'].
		char := stream next.
		skipNext
			ifTrue: [skipNext := false]
			ifFalse: [
				char = $$ 
					ifTrue: [skipNext := true]
					ifFalse: [
						char = $[ ifTrue: [nested := nested + 1].
						char = $] ifTrue: [nested := nested - 1].
						char = $' ifTrue: [self skipString].
						char = $" ifTrue: [self skipComment]]]].
	eol := stream eol size.
	^stream copyFrom: start + eol - 1 to: stream position - 1
! !

!TonelReader methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:40'!
read
	self
		readComments;
		readType;
		readDefinition;
		readMethods
! !

!TonelReader methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:40'!
readComments
	| start |
	stream skipSeparators.
	stream peek = $" ifTrue: [
		stream next.
		start := stream position.
		self skipComment.
		class at: #comment put: (stream contents copyFrom: start + 1 to: stream position - 1)]
! !

!TonelReader methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:40'!
readDefinition
	STONReader new
		on: stream skipSeparators;
		parseMapDo: [:key :value | class at: key put: value]
! !

!TonelReader methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:40'!
readMethod
	| metadata classname signature selector method |
	metadata := STON fromStream: stream.
	classname := stream skipSeparators; upToAll: '>>'.
	signature := stream upTo: $[.
	selector := SSmalltalkParser parseSelector: signature.
	method := OrderedDictionary new.
	method
		addAll: metadata;
		at: #class put: classname trimBlanks;
		at: #signature put: signature trimBlanks;
		at: #selector put: selector;
		at: #body put: self nextBlock.
	methods add: method
! !

!TonelReader methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:40'!
readMethods
	[stream skipSeparators; atEnd] whileFalse: [self readMethod]
! !

!TonelReader methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:40'!
readType
	| type |
	type := stream skipSeparators; nextWordOrNumber.
	(type = 'Class' or: [type = 'Extension'])
		ifFalse: [self error: 'unsupported type']
! !

!TonelReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
skipComment
	self skipToMatch: $"
! !

!TonelReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
skipString
	self skipToMatch: $'
! !

!TonelReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
skipToMatch: aCharacter
	[| found |
		found := stream skipTo: aCharacter.
		found ifFalse: [self error: aCharacter storeString , ' end expected'].
		stream peek = aCharacter ifTrue: [
			stream next.
			found := false].
		found] whileFalse
! !

!TonelReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stream: aReadStream
	stream := aReadStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TonelReader class' category: #Tonel!
TonelReader class
	instanceVariableNames: ''!

!TonelReader class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
on: aStream
	^self new stream: aStream
! !


TonelReader initialize!

