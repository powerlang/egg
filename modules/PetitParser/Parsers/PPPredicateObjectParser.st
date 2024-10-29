"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPPredicateObjectParser,
	#superclass : #PPPredicateParser,
	#category : #Parsers
}

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> any [
	| parser |
	parser := self
		on: [:each | true]
		message: 'input expected'
		negated: [:each | false]
		message: 'no input expected'.
	^parser name: #any
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> anyExceptAnyOf: aCollectionOfChars [
	^self
		on: [:each | (aCollectionOfChars includes: each) not]
		message: 'any except ' , aCollectionOfChars printString , ' expected'
		negated: [:each | aCollectionOfChars includes: each]
		message: aCollectionOfChars printString , ' not expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> anyOf: anArray [
	^self
		on: [:each | anArray includes: each]
		message: 'any of ' , anArray printString , ' expected'
		negated: [:each | (anArray includes: each) not]
		message: 'none of ' , anArray printString , 'expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> between: min and: max [
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> blank [
	| parser |
	parser := self
		chars: ((0 to: 32) collect: #asCharacter)
		message: 'blank expected'.
	^parser name: #blank
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> char: aCharacter [
	| parser |
	parser := self
		expect: aCharacter
		message: (String with: $" with: aCharacter with: $") , ' expected'.
	^parser name: aCharacter storeString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> char: aCharacter message: aString [
	^ self expect: aCharacter message: aString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> chars: aCollection message: aString [
	^ self on: (PPCharSetPredicate on: [ :char | aCollection includes: char ]) message: aString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> cr [
	| parser |
	parser := self char: Character cr message: 'carriage return expected'.
	^parser name: #cr
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> digit [
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isDigit)
		message: 'digit expected'.
	^parser name: #digit
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> expect: anObject [
	^ self expect: anObject message: anObject printString , ' expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> expect: anObject message: aString [
	^ self
		on: [ :each | each = anObject ] message: aString
		negated: [ :each | each ~= anObject ] message: 'no ' , aString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> hex [
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isHexDigit)
		message: 'hex digit expected'.
	^parser name: #hex
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> identifier [
	| parser |
	parser := self
		on: (PPCharSetPredicate on: [:char | char = $_ or: [char isAlphanumeric]])
		message: 'letter expected'.
	^parser name: #identifier
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> letter [
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isAsciiLetter)
		message: 'letter expected'.
	^parser name: #letter
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> lf [
	| parser |
	parser := self char: Character lf.
	^parser name: #lf
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> lowercase [
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isLowercase)
		message: 'lowercase letter expected'.
	^parser name: #lowercase
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> newline [
	| parser |
	parser := self
		chars: (String with: Character cr with: Character lf)
		message: 'newline expected'.
	^parser name: #newline
]

{ #category : #'instance creation' }
PPPredicateObjectParser class >> on: aBlock message: aString [
	^self
		on: aBlock
		message: aString
		negated: [:each | (aBlock value: each) not]
		message: 'no ' , aString
]

{ #category : #'instance creation' }
PPPredicateObjectParser class >> on: aBlock message: aString negated: aNegatedBlock message: aNegatedString [
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> punctuation [
	| parser |
	parser := self
		chars: '.,"''?!;:#$%&()*+-/<>=@[]\^_{}|~'
		message: 'punctuation expected'.
	^parser name: #punctuation
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> space [
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isBlank)
		message: 'separator expected'.
	^parser name: #space
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> tab [
	| parser |
	parser := self char: Character tab message: 'tab expected'.
	^parser name: #tab
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> uppercase [
	| parser |
	parser := self
		on: (PPCharSetPredicate on: #isUppercase)
		message: 'uppercase letter expected'.
	^parser name: 'uppercase'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> word [
	| parser |
	parser := self
		on: (PPCharSetPredicate
			on: [:char | char isLetter or: [char isDigit] or: [char = $_]])
		message: 'letter or digit expected'.
	^parser name: #word
]

{ #category : #initialization }
PPPredicateObjectParser >> initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString [
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString
]

{ #category : #operators }
PPPredicateObjectParser >> negate [
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
]

{ #category : #parsing }
PPPredicateObjectParser >> parseOn: aStream [
	^(aStream atEnd not and: [predicate value: aStream uncheckedPeek])
		ifFalse: [PPFailure message: predicateMessage from: aStream]
		ifTrue: [aStream next]
]

{ #category : #printing }
PPPredicateObjectParser >> printOn: aStream [
	self name isSymbol
		ifTrue: [
			self name storeOn: aStream.
			aStream nextPutAll: ' asParser']
		ifFalse: [super printOn: aStream]
]

{ #category : #printing }
PPPredicateObjectParser >> printTextOn: rtf [
	self name isSymbol
		ifTrue: [
			self name printTextOn: rtf.
			rtf nextPutAll: ' asParser']
		ifFalse: [super printTextOn: rtf]
]

