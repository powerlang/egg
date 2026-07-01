'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #CodeSearch category: #Development!
Object subclass: #CodeSearch
	instanceVariableNames: 'condition results sorter'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!CodeSearch commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!CodeSearch methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
condition
	^condition
! !

!CodeSearch methodsFor:  'condition' stamp: 'KenD 28/Jun/2026 13:32:24'!
conditionType: aSymbol
	| case |
	case := condition matchesCase.
	condition := CodeSearchCondition perform: aSymbol asSymbol.
	condition matchCase: case
! !

!CodeSearch methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultCondition
	^CodeSearchCondition beginning matchCase: true
! !

!CodeSearch methodsFor:  'condition' stamp: 'KenD 28/Jun/2026 13:32:24'!
ignoreCase: aBoolean
	condition matchCase: aBoolean not
! !

!CodeSearch methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
includes: aString
	^condition evaluateWith: aString
! !

!CodeSearch methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	condition := self defaultCondition.
	results := OrderedCollection new.
	self sortBySize
! !

!CodeSearch methodsFor:  'condition' stamp: 'KenD 28/Jun/2026 13:32:24'!
matchCase: aBoolean
	condition matchCase: aBoolean
! !

!CodeSearch methodsFor:  'condition' stamp: 'KenD 28/Jun/2026 13:32:24'!
pattern: aString
	condition := CodeSearchCondition matching: aString
! !

!CodeSearch methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:32:24'!
rawResults
	^results
! !

!CodeSearch methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
reset
	results removeAll
! !

!CodeSearch methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
search
	self subclassResponsibility
! !

!CodeSearch methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
search: aString
	condition text: aString.
	self reset; search.
	condition isSimilarity
		ifTrue: [sorter := [:r1 :r2 | (condition text editDistanceTo: r1 text)
			<= (condition text editDistanceTo: r2 text)]].
	^self sortedResults
! !

!CodeSearch methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sortAlphabetically
	sorter := [:r1 :r2 | r1 text <= r2 text]
! !

!CodeSearch methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
sortBySize
	sorter := [:r1 :r2 | r1 text size <= r2 text size]
! !

!CodeSearch methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:32:24'!
sortedResults
	^sorter ifNil: [results] ifNotNil: [results sortBy: sorter]
! !

!CodeSearch methodsFor:  'condition' stamp: 'KenD 28/Jun/2026 13:32:24'!
text: aString
	condition text: aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CodeSearch class' category: #Development!
CodeSearch class
	instanceVariableNames: ''!

!CodeSearch class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
search: aString
	"
	SelectorSearch search: 'abc'
	"
	^self new search: aString
! !

!CodeSearch class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
search: text in: type
	"
	CodeSearch search: 'abc' in: 'all'
	"
	^self search: text in: type ignoreCase: false conditionType: #beginning
! !

!CodeSearch class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
search: text in: type ignoreCase: ignoreCase conditionType: conditionType
	"
	CodeSearch search: 'a' in: 'all' ignoreCase: true position: #beginning
	"
	^(self searchClassesFor: type) gather: [:c | 
		c new
			ignoreCase: ignoreCase;
			conditionType: conditionType;
			search: text]
! !

!CodeSearch class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
searchClassesFor: type
	"
	CodeSearch searchClassesFor: 'all'
	CodeSearch searchClassesFor: 'implementors'
	"
	^type = 'all'
		ifTrue: [{ClassSearch. SelectorSearch. ProjectSearch. PoolSearch}]
		ifFalse: [self subclasses select: [:c | c type = type]]
! !

!CodeSearch class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
subclassesToSearch
	^subclasses copyWithout: ImplementorSearch
! !

!CodeSearch class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
type
	"
	CodeSearch type => 'all'
	ClassSearch type => 'classes'
	"
	^self == CodeSearch
		ifTrue: ['all']
		ifFalse: [(self name trimTail: 'Search') asLowercase]
! !


CodeSearch initialize!

