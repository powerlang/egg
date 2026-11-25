'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #StringPattern category: #Kernel!
Object subclass: #StringPattern
	instanceVariableNames: 'stream tokens'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!StringPattern commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!StringPattern methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:38'!
addStar
	stream atEnd ifTrue: [^self].
	tokens add: StarToken current.
	stream next.
	[stream peek ifNil: [^self] ifNotNil: [:c | c isAsterisk]]
		whileTrue: [stream next]
! !

!StringPattern methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:38'!
addToken
	| star pos end token |
	star := false.
	pos := stream position + 1.
	[stream atEnd or: [star := stream next isAsterisk]] whileFalse.
	star ifTrue: [stream skip: -1].
	end := stream position.
	pos <= end ifTrue: [
		token := MatchToken on: stream collection from: pos to: end.
		tokens add: token]
! !

!StringPattern methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
input
	^stream contents
! !

!StringPattern methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
match: aString
	^self match: aString index: 1
! !

!StringPattern methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
match: aString ifAbsent: aBlock
	^self match: aString index: 1 ifAbsent: aBlock
! !

!StringPattern methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
match: aString index: anInteger
	^self match: aString index: anInteger ifAbsent: nil
! !

!StringPattern methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
match: aString index: anInteger ifAbsent: aBlock
	| algorithm |
	algorithm := MatchAlgorithm new
		pattern: self;
		string: aString;
		index: anInteger.
	algorithm run.
	algorithm hasMatched ifTrue: [^algorithm matchRange].
	^aBlock notNil ifTrue: [
		aBlock arity = 0
			ifTrue: [aBlock value]
			ifFalse: [aBlock evaluateWith: algorithm failure]]
! !

!StringPattern methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
matches: aString
	| range |
	range := self match: aString.
	^range notNil and: [range x = 1 and: [range y = aString size]]
! !

!StringPattern methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aString
	stream := aString readStream.
	tokens := OrderedCollection new.
	self scan
! !

!StringPattern methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	tokens do: [:t | t printOn: aStream]
! !

!StringPattern methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:38'!
scan
	[stream atEnd] whileFalse: [self addToken; addStar]
! !

!StringPattern methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tokens
	^tokens copy
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StringPattern class' category: #Kernel!
StringPattern class
	instanceVariableNames: ''!

!StringPattern class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aString
	^self new on: aString
! !


