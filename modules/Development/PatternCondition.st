"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #PatternCondition, 
	#superclass : #CodeSearchCondition, 
	#category : #Development
}

{#category : #private}
PatternCondition >> compare: aString [
	^text match: aString
]

{#category : #private}
PatternCondition >> proposition [
	^'matches'
]

{#category : #accessing}
PatternCondition >> text: aString [
	| string |
	string := aString trimBlanks.
	string := matchCase ifTrue: [aString] ifFalse: [aString asLowercase].
	string first != $* ifTrue: [string := '*' , string].
	string last != $* ifTrue: [string := string , '*'].
	super text: string
]

