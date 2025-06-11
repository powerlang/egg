"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SimpleTestResource,
	#superclass : #TestResource,
	#instVars : [
		'runningState',
		'hasRun',
		'hasSetup',
		'hasRanOnce'
	],
	#category : #'SUnit.Tests'
}

{ #category : #unclassified }
SimpleTestResource >> hasRun [
	^hasRun
]

{ #category : #unclassified }
SimpleTestResource >> hasSetup [
	^hasSetup
]

{ #category : #unclassified }
SimpleTestResource >> isAvailable [
	^self runningState == self startedStateSymbol]

{ #category : #unclassified }
SimpleTestResource >> runningState [
	^runningState
]

{ #category : #unclassified }
SimpleTestResource >> runningState: aSymbol [
	runningState := aSymbol
]

{ #category : #unclassified }
SimpleTestResource >> setRun [
	hasRun := true
]

{ #category : #'set up' }
SimpleTestResource >> setUp [
	self runningState: self startedStateSymbol.
	hasSetup := true
]

{ #category : #unclassified }
SimpleTestResource >> startedStateSymbol [
	^#started
]

{ #category : #unclassified }
SimpleTestResource >> stoppedStateSymbol [
	^#stopped
]

{ #category : #finalization }
SimpleTestResource >> tearDown [
	self runningState: self stoppedStateSymbol
]

