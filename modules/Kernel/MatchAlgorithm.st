"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #MatchAlgorithm,
	#superclass : #Object,
	#instVars : [
		'string',
		'pattern',
		'start',
		'stop',
		'tokens',
		'failure',
		'ranges'
	],
	#category : #Kernel
}

{ #category : #private }
MatchAlgorithm >> failBecause: aString [
	failure := aString
]

{ #category : #outputs }
MatchAlgorithm >> failure [
	^failure
]

{ #category : #outputs }
MatchAlgorithm >> hasMatched [
	^failure isNil and: [tokens isEmpty]
]

{ #category : #testing }
MatchAlgorithm >> hasTokens [
	^failure isNil and: [tokens notEmpty]
]

{ #category : #inputs }
MatchAlgorithm >> index: anInteger [
	start := anInteger
]

{ #category : #initialization }
MatchAlgorithm >> initialize [
	super initialize.
	start := 1
]

{ #category : #computing }
MatchAlgorithm >> matchFirstStar [
	| range |
	range := string start @ nil.
	ranges add: tokens first -> range.
	tokens removeFirst.
	self hasTokens
		ifTrue: [tokens first matchFirstAfterStartOn: self]
		ifFalse: [
			range y: string stop.
			string stop: string start - 1]
]

{ #category : #computing }
MatchAlgorithm >> matchFirstToken [
	| token min match save |
	token := tokens first.
	min := token length.
	match := false.
	save := string start.
	[
		string length >= min and: [
			match := string beginsWith: token.
			match not]]
		whileTrue: [string start: string start + 1].
	match
		ifTrue: [
			ranges add: token -> (string start @ (string start + min - 1)).
			string start: string start + token length.
			tokens removeFirst]
		ifFalse: [
			tokens size = 1 ifTrue: [
				string start: save.
				^self privateMatchLastToken].
			self
				failBecause: token asString , ' not present at position '
					, string start printString]
]

{ #category : #computing }
MatchAlgorithm >> matchFirstTokenAfterStar [
	| token i |
	token := tokens first.
	i := string indexOf: token.
	i = 0
		ifTrue: [
			self
				failBecause: token asString , ' not present in inteval ['
					, string start printString
					, ', '
					, string stop printString]
		ifFalse: [
			ranges last value y: i - 1.
			ranges add: token -> (i @ (i + token length - 1)).
			string start: i + token length.
			tokens removeFirst]
]

{ #category : #computing }
MatchAlgorithm >> matchLastToken [
	tokens size = 1
		ifTrue: [self matchFirstToken]
		ifFalse: [self privateMatchLastToken]
]

{ #category : #computing }
MatchAlgorithm >> matchNextToken [
	tokens first matchFirstOn: self
]

{ #category : #outputs }
MatchAlgorithm >> matchRange [
	| sorted |
	sorted := ranges collect: #value thenSelect: [:p | p x <= p y].
	sorted := sorted asSortedCollection: [:p :q | p x < q x].
	^sorted notEmpty ifTrue: [sorted first x @ sorted last y]
]

{ #category : #inputs }
MatchAlgorithm >> pattern: aStringPattern [
	pattern := aStringPattern
]

{ #category : #computing }
MatchAlgorithm >> privateMatchLastToken [
	| token min match |
	token := tokens last.
	min := token length.
	match := false.
	[
		string length >= min and: [
			match := string endsWith: token.
			match not]]
		whileTrue: [string stop: string stop - 1].
	match
		ifTrue: [
			ranges add: token -> (string stop - min + 1 @ string stop).
			string stop: string stop - token length.
			tokens removeLast]
		ifFalse: [
			self
				failBecause: token asString , ' not present at position '
					, (string stop - token length + 1) printString]
]

{ #category : #private }
MatchAlgorithm >> reset [
	| end |
	failure := nil.
	tokens := pattern tokens.
	string start: start.
	end := stop notNil ifTrue: [stop] ifFalse: [string string size].
	string stop: end.
	ranges := OrderedCollection new: tokens size
]

{ #category : #computing }
MatchAlgorithm >> run [
	self reset.
	tokens isEmpty ifTrue: [^self].
	tokens last matchLastOn: self.
	[self hasTokens] whileTrue: [self matchNextToken]
]

{ #category : #inputs }
MatchAlgorithm >> string: aString [
	string := MatchToken on: aString from: 1 to: aString size
]

