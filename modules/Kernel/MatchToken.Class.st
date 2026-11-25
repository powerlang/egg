'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #MatchToken category: #Kernel!
Object subclass: #MatchToken
	instanceVariableNames: 'string start stop'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!MatchToken commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!MatchToken methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asString
	^string copyFrom: start to: stop
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: i
	^string at: i
! !

!MatchToken methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
beginsWith: aMatchToken
	self length >= aMatchToken length ifFalse: [^false].
	aMatchToken start to: aMatchToken stop do: [:i | | char |
		char := aMatchToken at: i.
		((self at: start + i - 1) = char or: [char isQuestionMark]) ifFalse: [^false]].
	^true
! !

!MatchToken methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
endsWith: aMatchToken
	| end |
	self length >= aMatchToken length ifFalse: [^false].
	end := aMatchToken stop.
	end to: aMatchToken start by: -1 do: [:i | | char |
		char := aMatchToken at: i.
		((self at: stop - end + i) = char or: [char isQuestionMark]) ifFalse: [^false]].
	^true
! !

!MatchToken methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOf: aMatchToken
	^string indexOfString: aMatchToken asString from: start to: stop
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
length
	^stop - start + 1
! !

!MatchToken methodsFor:  'double dispatching' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchFirstAfterStartOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstTokenAfterStar
! !

!MatchToken methodsFor:  'double dispatching' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchFirstOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstToken
! !

!MatchToken methodsFor:  'double dispatching' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchLastOn: aMatchAlgorithm
	aMatchAlgorithm matchLastToken
! !

!MatchToken methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	start to: stop do: [:i | aStream nextPut: (string at: i)]
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
start
	^start
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
start: anInteger
	start := anInteger
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
stop
	^stop
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
stop: anInteger
	stop := anInteger
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
string
	^string
! !

!MatchToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
string: aString
	string := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MatchToken class' category: #Kernel!
MatchToken class
	instanceVariableNames: ''!

!MatchToken class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aString from: start to: stop
	^self new
		string: aString;
		start: start;
		stop: stop
! !


