"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonStringSchema,
	#superclass : #JsonPrimitiveSchema,
	#instVars : [
		'minLength',
		'maxLength'
	],
	#category : #JSON
}

{ #category : #converting }
JsonStringSchema >> asJson [
	| json |
	json := super asJson.
	minLength notNil ifTrue: [json at: 'minLength' put: minLength].
	maxLength notNil ifTrue: [json at: 'maxLength' put: maxLength].
	^json
]

{ #category : #accessing }
JsonStringSchema >> defaultFormat [
	^JsonStringFormat new
]

{ #category : #testing }
JsonStringSchema >> isStringSchema [
	^true
]

{ #category : #accessing }
JsonStringSchema >> maxLength [
	^maxLength
]

{ #category : #accessing }
JsonStringSchema >> maxLength: anInteger [
	maxLength := anInteger
]

{ #category : #accessing }
JsonStringSchema >> minLength [
	^minLength
]

{ #category : #accessing }
JsonStringSchema >> minLength: anInteger [
	minLength := anInteger
]

