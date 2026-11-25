'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPPredicateObjectParser category: #Parsers!
PPPredicateParser subclass: #PPPredicateObjectParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPPredicateObjectParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPPredicateObjectParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString
! !

!PPPredicateObjectParser methodsFor:  'operators' stamp: 'KenD 28/Jun/2026 13:27:39'!
negate
	"
	Answer a parser that is the negation of the receiving predicate parser.
	"
	| parser name |
	parser := self class
		on: negated
		message: negatedMessage
		negated: predicate
		message: predicateMessage.
	name := self name ifNil: [^parser].
	^parser name: name , ' negate'
! !

!PPPredicateObjectParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	^(aStream atEnd not and: [predicate value: aStream uncheckedPeek])
		ifFalse: [PPFailure message: predicateMessage from: aStream]
		ifTrue: [aStream next]
! !

!PPPredicateObjectParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	self name isSymbol
		ifTrue: [
			self name storeOn: aStream.
			aStream nextPutAll: ' asParser']
		ifFalse: [super printOn: aStream]
! !

!PPPredicateObjectParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	self name isSymbol
		ifTrue: [
			self name printTextOn: rtf.
			rtf nextPutAll: ' asParser']
		ifFalse: [super printTextOn: rtf]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPPredicateObjectParser class' category: #Parsers!
PPPredicateObjectParser class
	instanceVariableNames: ''!

!PPPredicateObjectParser class methodsFor:  'factory-objects' stamp: 'KenD 28/Jun/2026 13:27:39'!
any
	| parser |
	parser := self
		on: [:each | true]
		message: 'input expected'
		negated: [:each | false]
		message: 'no input expected'.
	^parser name: #any
! !

!PPPredicateObjectParser class methodsFor:  'factory-objects' stamp: 'KenD 28/Jun/2026 13:27:39'!
anyExceptAnyOf: aCollectionOfChars
	^self
		on: [:each | (aCollectionOfChars includes: each) not]
		message: 'any except ' , aCollectionOfChars printString , ' expected'
		negated: [:each | aCollectionOfChars includes: each]
		message: aCollectionOfChars printString , ' not expected'
! !

!PPPredicateObjectParser class methodsFor:  'factory-objects' stamp: 'KenD 28/Jun/2026 13:27:39'!
anyOf: anArray
	^self
		on: [:each | anArray includes: each]
		message: 'any of ' , anArray printString , ' expected'
		negated: [:each | (anArray includes: each) not]
		message: 'none of ' , anArray printString , 'expected'
! !

!PPPredicateObjectParser class methodsFor:  'factory-objects' stamp: 'KenD 28/Jun/2026 13:27:39'!
between: min and: max
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
blank
	| parser |
	parser := self
		chars: ((0 to: 32) collect: #asCharacter)
		message: 'blank expected'.
	^parser name: #blank
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
char: aCharacter
	| parser |
	parser := self
		expect: aCharacter
		message: (String with: $" with: aCharacter with: $") , ' expected'.
	^parser name: aCharacter storeString
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
char: aCharacter message: aString
	^ self expect: aCharacter message: aString
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
chars: aCollection message: aString
	^ self on: (PPCharSetPredicate on: [ :char | aCollection includes: char ]) message: aString
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
cr
	| parser |
	parser := self char: Character cr message: 'carriage return expected'.
	^parser name: #cr
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
digit
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isDigit)
		message: 'digit expected'.
	^parser name: #digit
! !

!PPPredicateObjectParser class methodsFor:  'factory-objects' stamp: 'KenD 28/Jun/2026 13:27:39'!
expect: anObject
	^ self expect: anObject message: anObject printString , ' expected'
! !

!PPPredicateObjectParser class methodsFor:  'factory-objects' stamp: 'KenD 28/Jun/2026 13:27:39'!
expect: anObject message: aString
	^ self
		on: [ :each | each = anObject ] message: aString
		negated: [ :each | each ~= anObject ] message: 'no ' , aString
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
hex
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isHexDigit)
		message: 'hex digit expected'.
	^parser name: #hex
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
identifier
	| parser |
	parser := self
		on: (PPCharSetPredicate on: [:char | char = $_ or: [char isAlphanumeric]])
		message: 'letter expected'.
	^parser name: #identifier
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
letter
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isAsciiLetter)
		message: 'letter expected'.
	^parser name: #letter
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
lf
	| parser |
	parser := self char: Character lf.
	^parser name: #lf
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
lowercase
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isLowercase)
		message: 'lowercase letter expected'.
	^parser name: #lowercase
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
newline
	| parser |
	parser := self
		chars: (String with: Character cr with: Character lf)
		message: 'newline expected'.
	^parser name: #newline
! !

!PPPredicateObjectParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aBlock message: aString
	^self
		on: aBlock
		message: aString
		negated: [:each | (aBlock value: each) not]
		message: 'no ' , aString
! !

!PPPredicateObjectParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aBlock message: aString negated: aNegatedBlock message: aNegatedString
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
punctuation
	| parser |
	parser := self
		chars: '.,"''?!!;:#$%&()*+-/<>=@[]\^_{}|~'
		message: 'punctuation expected'.
	^parser name: #punctuation
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
space
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isBlank)
		message: 'separator expected'.
	^parser name: #space
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
tab
	| parser |
	parser := self char: Character tab message: 'tab expected'.
	^parser name: #tab
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
uppercase
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isUppercase)
		message: 'uppercase letter expected'.
	^parser name: 'uppercase'
! !

!PPPredicateObjectParser class methodsFor:  'factory-chars' stamp: 'KenD 28/Jun/2026 13:27:39'!
word
	| parser |
	parser := self
		on: (PPCharSetPredicate
			on: [:char | char isLetter or: [char isDigit] or: [char = $_]])
		message: 'letter or digit expected'.
	^parser name: #word
! !


