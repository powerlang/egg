"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPListParser,
	#superclass : #PPParser,
	#instVars : [
		'parsers'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPListParser class >> with: aParser [
	^self withAll: {aParser}
]

{ #category : #'instance creation' }
PPListParser class >> with: aFirstParser with: aSecondParser [
	^self withAll: {aFirstParser. aSecondParser}
]

{ #category : #'instance creation' }
PPListParser class >> withAll: aCollection [
	^ self basicNew setParsers: aCollection
]

{ #category : #accessing }
PPListParser >> children [
	^ parsers
]

{ #category : #copying }
PPListParser >> copyWith: aParser [
	^ self species withAll: (parsers copyWith: aParser)
]

{ #category : #initialization }
PPListParser >> initialize [
	super initialize.
	self setParsers: #()
]

{ #category : #copying }
PPListParser >> postCopy [
	super postCopy.
	parsers := parsers copy
]

{ #category : #initialization }
PPListParser >> setParsers: aCollection [
	parsers := aCollection asArray
]

