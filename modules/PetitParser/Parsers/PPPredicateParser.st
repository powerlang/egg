"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPPredicateParser,
	#superclass : #PPParser,
	#instVars : [
		'predicate',
		'predicateMessage',
		'negated',
		'negatedMessage'
	],
	#category : #Parsers
}

{ #category : #accessing }
PPPredicateParser >> block [
	"Answer the predicate block of the receiver."

	^ predicate
]

{ #category : #accessing }
PPPredicateParser >> message [
	"Answer the failure message."

	^ predicateMessage
]

{ #category : #printing }
PPPredicateParser >> printNameOn: aStream [
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: predicateMessage
]

