"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #MatchToken,
	#superclass : #Object,
	#instVars : [
		'string',
		'start',
		'stop'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
MatchToken class >> on: aString from: start to: stop [
	^self new
		string: aString;
		start: start;
		stop: stop
]

{ #category : #converting }
MatchToken >> asString [
	^string copyFrom: start to: stop
]

{ #category : #accessing }
MatchToken >> at: i [
	^string at: i
]

{ #category : #inquiries }
MatchToken >> beginsWith: aMatchToken [
	self length >= aMatchToken length ifFalse: [^false].
	aMatchToken start to: aMatchToken stop do: [:i | | char |
		char := aMatchToken at: i.
		((self at: start + i - 1) = char or: [char isQuestionMark]) ifFalse: [^false]].
	^true
]

{ #category : #inquiries }
MatchToken >> endsWith: aMatchToken [
	| end |
	self length >= aMatchToken length ifFalse: [^false].
	end := aMatchToken stop.
	end to: aMatchToken start by: -1 do: [:i | | char |
		char := aMatchToken at: i.
		((self at: stop - end + i) = char or: [char isQuestionMark]) ifFalse: [^false]].
	^true
]

{ #category : #inquiries }
MatchToken >> indexOf: aMatchToken [
	^string indexOfString: aMatchToken asString from: start to: stop
]

{ #category : #accessing }
MatchToken >> length [
	^stop - start + 1
]

{ #category : #'double dispatching' }
MatchToken >> matchFirstAfterStartOn: aMatchAlgorithm [
	aMatchAlgorithm matchFirstTokenAfterStar
]

{ #category : #'double dispatching' }
MatchToken >> matchFirstOn: aMatchAlgorithm [
	aMatchAlgorithm matchFirstToken
]

{ #category : #'double dispatching' }
MatchToken >> matchLastOn: aMatchAlgorithm [
	aMatchAlgorithm matchLastToken
]

{ #category : #printing }
MatchToken >> printOn: aStream [
	start to: stop do: [:i | aStream nextPut: (string at: i)]
]

{ #category : #accessing }
MatchToken >> start [
	^start
]

{ #category : #accessing }
MatchToken >> start: anInteger [
	start := anInteger
]

{ #category : #accessing }
MatchToken >> stop [
	^stop
]

{ #category : #accessing }
MatchToken >> stop: anInteger [
	stop := anInteger
]

{ #category : #accessing }
MatchToken >> string [
	^string
]

{ #category : #accessing }
MatchToken >> string: aString [
	string := aString
]

