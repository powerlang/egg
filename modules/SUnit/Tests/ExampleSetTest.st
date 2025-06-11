"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ExampleSetTest,
	#superclass : #TestCase,
	#instVars : [
		'full',
		'empty'
	],
	#category : #'SUnit.Tests'
}

{ #category : #'set up' }
ExampleSetTest >> setUp [
	empty := Set new.
	full := Set with: 5 with: #abc
]

{ #category : #all }
ExampleSetTest >> testAdd [
	empty add: 5.
	self assert: (empty includes: 5)
]

{ #category : #all }
ExampleSetTest >> testGrow [
	empty addAll: (1 to: 100).
	self assert: empty size = 100
]

{ #category : #all }
ExampleSetTest >> testIllegal [
	self 
		should: [empty at: 5] 
		raise: TestResult error.
	self 
		should: [empty at: 5 put: #abc] 
		raise: TestResult error
]

{ #category : #all }
ExampleSetTest >> testIncludes [
	self assert: (full includes: 5).
	self assert: (full includes: #abc)
]

{ #category : #all }
ExampleSetTest >> testOccurrences [
	self assert: (empty occurrencesOf: 0) = 0.
	self assert: (full occurrencesOf: 5) = 1.
	full add: 5.
	self assert: (full occurrencesOf: 5) = 1
]

{ #category : #all }
ExampleSetTest >> testRemove [
	full remove: 5.
	self assert: (full includes: #abc).
	self deny: (full includes: 5)
]

