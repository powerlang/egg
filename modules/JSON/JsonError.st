"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonError,
	#superclass : #Error,
	#instVars : [
		'position',
		'context'
	],
	#category : #JSON
}

{ #category : #services }
JsonError class >> signal: aString at: anInteger [
	^self new position: anInteger; description: aString; signal
]

{ #category : #services }
JsonError class >> signal: aString at: anInteger context: context [
	^self new
		position: anInteger;
		description: aString;
		context: context;
		signal
]

{ #category : #accessing }
JsonError >> context: aString [
	context := aString
]

{ #category : #accessing }
JsonError >> description [
	^'Cannot parse the JSON stream around ' , context storeString , ' because '
		, super description
]

{ #category : #accessing }
JsonError >> position [
	^position
]

{ #category : #accessing }
JsonError >> position: anInteger [
	position := anInteger
]

