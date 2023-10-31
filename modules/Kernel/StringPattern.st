"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #StringPattern,
	#superclass : #Object,
	#instVars : [
		'stream',
		'tokens'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
StringPattern class >> on: aString [
	^self new on: aString
]

{ #category : #scanning }
StringPattern >> addStar [
	stream atEnd ifTrue: [^self].
	tokens add: StarToken current.
	stream next.
	[stream peek ifNil: [^self] ifNotNil: [:c | c isAsterisk]]
		whileTrue: [stream next]
]

{ #category : #scanning }
StringPattern >> addToken [
	| star pos end token |
	star := false.
	pos := stream position + 1.
	[stream atEnd or: [star := stream next isAsterisk]] whileFalse.
	star ifTrue: [stream skip: -1].
	end := stream position.
	pos <= end ifTrue: [
		token := MatchToken on: stream collection from: pos to: end.
		tokens add: token]
]

{ #category : #accessing }
StringPattern >> input [
	^stream contents
]

{ #category : #inquiries }
StringPattern >> match: aString [
	^self match: aString index: 1
]

{ #category : #inquiries }
StringPattern >> match: aString ifAbsent: aBlock [
	^self match: aString index: 1 ifAbsent: aBlock
]

{ #category : #inquiries }
StringPattern >> match: aString index: anInteger [
	^self match: aString index: anInteger ifAbsent: nil
]

{ #category : #inquiries }
StringPattern >> match: aString index: anInteger ifAbsent: aBlock [
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
]

{ #category : #inquiries }
StringPattern >> matches: aString [
	| range |
	range := self match: aString.
	^range notNil and: [range x = 1 and: [range y = aString size]]
]

{ #category : #accessing }
StringPattern >> on: aString [
	stream := aString readStream.
	tokens := OrderedCollection new.
	self scan
]

{ #category : #printing }
StringPattern >> printOn: aStream [
	tokens do: [:t | t printOn: aStream]
]

{ #category : #scanning }
StringPattern >> scan [
	[stream atEnd] whileFalse: [self addToken; addStar]
]

{ #category : #accessing }
StringPattern >> tokens [
	^tokens copy
]

