"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPMappedParser,
	#superclass : #PPListParser,
	#category : #Parsers
}

{ #category : #accessing }
PPMappedParser >> at: key put: aPPParser [
	parsers at: key put: aPPParser
]

{ #category : #initialization }
PPMappedParser >> initialize [
	super initialize.
	parsers := Dictionary new
]

{ #category : #parsing }
PPMappedParser >> parseOn: aStream [
	| key parser |
	key := aStream peek.
	key isNil
		ifTrue: [^PPFailure
			message: 'no parser for key ' , key printString
			from: aStream].
	parser := parsers
		at: key
		ifAbsent: [^PPFailure
			message: 'no parser for key ' , key printString
			from: aStream].
	^parser parseOn: aStream
]

{ #category : #initialization }
PPMappedParser >> setParsers: aDictionary [
	parsers := aDictionary
]

