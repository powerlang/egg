'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #MatchAlgorithm category: #Kernel!
Object subclass: #MatchAlgorithm
	instanceVariableNames: 'string pattern start stop tokens failure ranges'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!MatchAlgorithm commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!MatchAlgorithm methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
failBecause: aString
	failure := aString
! !

!MatchAlgorithm methodsFor:  'outputs' stamp: 'KenD 28/Jun/2026 13:27:38'!
failure
	^failure
! !

!MatchAlgorithm methodsFor:  'outputs' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasMatched
	^failure isNil and: [tokens isEmpty]
! !

!MatchAlgorithm methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasTokens
	^failure isNil and: [tokens notEmpty]
! !

!MatchAlgorithm methodsFor:  'inputs' stamp: 'KenD 28/Jun/2026 13:27:38'!
index: anInteger
	start := anInteger
! !

!MatchAlgorithm methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	start := 1
! !

!MatchAlgorithm methodsFor:  'computing' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchFirstStar
	| range |
	range := string start @ nil.
	ranges add: tokens first -> range.
	tokens removeFirst.
	self hasTokens
		ifTrue: [tokens first matchFirstAfterStartOn: self]
		ifFalse: [
			range y: string stop.
			string stop: string start - 1]
! !

!MatchAlgorithm methodsFor:  'computing' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchFirstToken
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
! !

!MatchAlgorithm methodsFor:  'computing' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchFirstTokenAfterStar
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
! !

!MatchAlgorithm methodsFor:  'computing' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchLastToken
	tokens size = 1
		ifTrue: [self matchFirstToken]
		ifFalse: [self privateMatchLastToken]
! !

!MatchAlgorithm methodsFor:  'computing' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchNextToken
	tokens first matchFirstOn: self
! !

!MatchAlgorithm methodsFor:  'outputs' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchRange
	| sorted |
	sorted := ranges collect: #value thenSelect: [:p | p x <= p y].
	sorted := sorted asSortedCollection: [:p :q | p x < q x].
	^sorted notEmpty ifTrue: [sorted first x @ sorted last y]
! !

!MatchAlgorithm methodsFor:  'inputs' stamp: 'KenD 28/Jun/2026 13:27:38'!
pattern: aStringPattern
	pattern := aStringPattern
! !

!MatchAlgorithm methodsFor:  'computing' stamp: 'KenD 28/Jun/2026 13:27:38'!
privateMatchLastToken
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
! !

!MatchAlgorithm methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reset
	| end |
	failure := nil.
	tokens := pattern tokens.
	string start: start.
	end := stop notNil ifTrue: [stop] ifFalse: [string string size].
	string stop: end.
	ranges := OrderedCollection new: tokens size
! !

!MatchAlgorithm methodsFor:  'computing' stamp: 'KenD 28/Jun/2026 13:27:38'!
run
	self reset.
	tokens isEmpty ifTrue: [^self].
	tokens last matchLastOn: self.
	[self hasTokens] whileTrue: [self matchNextToken]
! !

!MatchAlgorithm methodsFor:  'inputs' stamp: 'KenD 28/Jun/2026 13:27:38'!
string: aString
	string := MatchToken on: aString from: 1 to: aString size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MatchAlgorithm class' category: #Kernel!
MatchAlgorithm class
	instanceVariableNames: ''!


MatchAlgorithm initialize!

