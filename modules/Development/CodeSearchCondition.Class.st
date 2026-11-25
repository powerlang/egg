'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #CodeSearchCondition category: #Development!
Object subclass: #CodeSearchCondition
	instanceVariableNames: 'text matchCase'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!CodeSearchCondition commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!CodeSearchCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
compare: aString
	self subclassResponsibility
! !

!CodeSearchCondition methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:32:24'!
evaluateWith: aString
	| string |
	string := matchCase ifTrue: [aString] ifFalse: [aString asLowercase].
	^self compare: string
! !

!CodeSearchCondition methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	matchCase := true
! !

!CodeSearchCondition methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isEmpty
	^text isEmptyOrNil
! !

!CodeSearchCondition methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isExactMatch
	^false
! !

!CodeSearchCondition methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isSimilarity
	^false
! !

!CodeSearchCondition methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
matchCase: aBoolean
	matchCase := aBoolean
! !

!CodeSearchCondition methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
matchesCase
	^matchCase
! !

!CodeSearchCondition methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	| case |
	case := matchCase ifTrue: ['sensitive'] ifFalse: ['insensitive'].
	aStream
		nextPutAll: self proposition;
		space;
		nextPutAll: (text ifNil: '');
		nextPutAll: ' (case ' , case , ')'
! !

!CodeSearchCondition methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
text
	^text
! !

!CodeSearchCondition methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
text: aString
	text := matchCase ifTrue: [aString] ifFalse: [aString asLowercase]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CodeSearchCondition class' category: #Development!
CodeSearchCondition class
	instanceVariableNames: ''!

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
beginning
	^BeginningCondition new
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
beginningWith: aString
	^self beginning text: aString
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
ending
	^EndingCondition new
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
endingWith: aString
	^self ending text: aString
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
exact
	^ExactMatchCondition new
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
including
	^IncludingCondition new
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
including: aString
	^self including text: aString
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
matching: aString
	^PatternCondition new text: aString
! !

!CodeSearchCondition class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
similar
	^SimilarityCondition new
! !


CodeSearchCondition initialize!

