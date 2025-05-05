"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #CodeSearchCondition, 
	#superclass : #Object, 
	#instVars : [
		'text', 
		'matchCase'
	], 
	#category : #Development
}

{#category : #'instance creation'}
CodeSearchCondition class >> beginning [
	^BeginningCondition new
]

{#category : #'instance creation'}
CodeSearchCondition class >> beginningWith: aString [
	^self beginning text: aString
]

{#category : #'instance creation'}
CodeSearchCondition class >> ending [
	^EndingCondition new
]

{#category : #'instance creation'}
CodeSearchCondition class >> endingWith: aString [
	^self ending text: aString
]

{#category : #'instance creation'}
CodeSearchCondition class >> exact [
	^ExactMatchCondition new
]

{#category : #'instance creation'}
CodeSearchCondition class >> including [
	^IncludingCondition new
]

{#category : #'instance creation'}
CodeSearchCondition class >> including: aString [
	^self including text: aString
]

{#category : #'instance creation'}
CodeSearchCondition class >> matching: aString [
	^PatternCondition new text: aString
]

{#category : #'instance creation'}
CodeSearchCondition class >> similar [
	^SimilarityCondition new
]

{#category : #private}
CodeSearchCondition >> compare: aString [
	self subclassResponsibility
]

{#category : #evaluating}
CodeSearchCondition >> evaluateWith: aString [
	| string |
	string := matchCase ifTrue: [aString] ifFalse: [aString asLowercase].
	^self compare: string
]

{#category : #initialization}
CodeSearchCondition >> initialize [
	super initialize.
	matchCase := true
]

{#category : #testing}
CodeSearchCondition >> isEmpty [
	^text isEmptyOrNil
]

{#category : #testing}
CodeSearchCondition >> isExactMatch [
	^false
]

{#category : #testing}
CodeSearchCondition >> isSimilarity [
	^false
]

{#category : #accessing}
CodeSearchCondition >> matchCase: aBoolean [
	matchCase := aBoolean
]

{#category : #testing}
CodeSearchCondition >> matchesCase [
	^matchCase
]

{#category : #printing}
CodeSearchCondition >> printOn: aStream [
	| case |
	case := matchCase ifTrue: ['sensitive'] ifFalse: ['insensitive'].
	aStream
		nextPutAll: self proposition;
		space;
		nextPutAll: (text ifNil: '');
		nextPutAll: ' (case ' , case , ')'
]

{#category : #accessing}
CodeSearchCondition >> text [
	^text
]

{#category : #accessing}
CodeSearchCondition >> text: aString [
	text := matchCase ifTrue: [aString] ifFalse: [aString asLowercase]
]

