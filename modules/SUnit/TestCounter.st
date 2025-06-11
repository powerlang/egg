"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TestCounter,
	#superclass : #Object,
	#instVars : [
		'checks'
	],
	#category : #SUnit
}

{ #category : #accessing }
TestCounter >> addCounter: aTestCounter [
	checks addAll: aTestCounter checks
]

{ #category : #printing }
TestCounter >> checkDescriptions [
	| description stream |
	description := OrderedCollection new.
	checks withOccurrencesDo: [:selector :total | 
		stream := '' writeStream.
		stream
			nextPutAll: '   > ';
			print: selector;
			space;
			print: total.
		description add: stream contents].
	^description
]

{ #category : #accessing }
TestCounter >> checks [
	^checks
]

{ #category : #accessing }
TestCounter >> count: aspect [
	checks add: aspect
]

{ #category : #initialization }
TestCounter >> initialize [
	super initialize.
	checks := Bag new
]

{ #category : #inquiries }
TestCounter >> occurrencesOf: aSymbol [
	^checks occurrencesOf: aSymbol
]

{ #category : #accessing }
TestCounter >> reset [
	checks removeAll
]

{ #category : #inquiries }
TestCounter >> totalChecks [
	^checks size
]

