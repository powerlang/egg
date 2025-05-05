"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #CodeSearch, 
	#superclass : #Object, 
	#instVars : [
		'condition', 
		'results', 
		'sorter'
	], 
	#category : #Development
}

{#category : #services}
CodeSearch class >> search: aString [
	"
	SelectorSearch search: 'abc'
	"
	^self new search: aString
]

{#category : #services}
CodeSearch class >> search: text in: type [
	"
	CodeSearch search: 'abc' in: 'all'
	"
	^self search: text in: type ignoreCase: false conditionType: #beginning
]

{#category : #services}
CodeSearch class >> search: text
in: type
ignoreCase: ignoreCase
conditionType: conditionType [
	"
	CodeSearch search: 'a' in: 'all' ignoreCase: true position: #beginning
	"
	^(self searchClassesFor: type) gather: [:c | 
		c new
			ignoreCase: ignoreCase;
			conditionType: conditionType;
			search: text]
]

{#category : #private}
CodeSearch class >> searchClassesFor: type [
	"
	CodeSearch searchClassesFor: 'all'
	CodeSearch searchClassesFor: 'implementors'
	"
	^type = 'all'
		ifTrue: [{ClassSearch. SelectorSearch. ProjectSearch. PoolSearch}]
		ifFalse: [self subclasses select: [:c | c type = type]]
]

{#category : #services}
CodeSearch class >> subclassesToSearch [
	^subclasses copyWithout: ImplementorSearch
]

{#category : #private}
CodeSearch class >> type [
	"
	CodeSearch type => 'all'
	ClassSearch type => 'classes'
	"
	^self == CodeSearch
		ifTrue: ['all']
		ifFalse: [(self name trimTail: 'Search') asLowercase]
]

{#category : #accessing}
CodeSearch >> condition [
	^condition
]

{#category : #condition}
CodeSearch >> conditionType: aSymbol [
	| case |
	case := condition matchesCase.
	condition := CodeSearchCondition perform: aSymbol asSymbol.
	condition matchCase: case
]

{#category : #private}
CodeSearch >> defaultCondition [
	^CodeSearchCondition beginning matchCase: true
]

{#category : #condition}
CodeSearch >> ignoreCase: aBoolean [
	condition matchCase: aBoolean not
]

{#category : #private}
CodeSearch >> includes: aString [
	^condition evaluateWith: aString
]

{#category : #initialization}
CodeSearch >> initialize [
	super initialize.
	condition := self defaultCondition.
	results := OrderedCollection new.
	self sortBySize
]

{#category : #condition}
CodeSearch >> matchCase: aBoolean [
	condition matchCase: aBoolean
]

{#category : #condition}
CodeSearch >> pattern: aString [
	condition := CodeSearchCondition matching: aString
]

{#category : #inquiries}
CodeSearch >> rawResults [
	^results
]

{#category : #private}
CodeSearch >> reset [
	results removeAll
]

{#category : #services}
CodeSearch >> search [
	self subclassResponsibility
]

{#category : #services}
CodeSearch >> search: aString [
	condition text: aString.
	self reset; search.
	condition isSimilarity
		ifTrue: [sorter := [:r1 :r2 | (condition text editDistanceTo: r1 text)
			<= (condition text editDistanceTo: r2 text)]].
	^self sortedResults
]

{#category : #accessing}
CodeSearch >> sortAlphabetically [
	sorter := [:r1 :r2 | r1 text <= r2 text]
]

{#category : #accessing}
CodeSearch >> sortBySize [
	sorter := [:r1 :r2 | r1 text size <= r2 text size]
]

{#category : #inquiries}
CodeSearch >> sortedResults [
	^sorter ifNil: [results] ifNotNil: [results sortBy: sorter]
]

{#category : #condition}
CodeSearch >> text: aString [
	condition text: aString
]

