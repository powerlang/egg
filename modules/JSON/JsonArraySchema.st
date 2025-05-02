"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonArraySchema,
	#superclass : #JsonSchema,
	#instVars : [
		'items',
		'minItems',
		'maxItems',
		'uniqueItems'
	],
	#category : #JSON
}

{ #category : #converting }
JsonArraySchema >> asJson [
	| json |
	json := super asJson.
	items notNil ifTrue: [json items: items asJson].
	minItems notNil ifTrue: [json at: 'minItems' put: minItems].
	maxItems notNil ifTrue: [json at: 'maxItems' put: maxItems].
	^json
]

{ #category : #initialization }
JsonArraySchema >> initialize [
	super initialize.
	uniqueItems := false
]

{ #category : #testing }
JsonArraySchema >> isArraySchema [
	^true
]

{ #category : #accessing }
JsonArraySchema >> items [
	^items
]

{ #category : #accessing }
JsonArraySchema >> items: aJsonSchema [
	items := aJsonSchema.
	aJsonSchema parent: self
]

{ #category : #accessing }
JsonArraySchema >> maxItems [
	^maxItems
]

{ #category : #accessing }
JsonArraySchema >> maxItems: aNumber [
	maxItems := aNumber
]

{ #category : #accessing }
JsonArraySchema >> minItems [
	^minItems
]

{ #category : #accessing }
JsonArraySchema >> minItems: aNumber [
	minItems := aNumber
]

{ #category : #accessing }
JsonArraySchema >> uniqueItems [
	^uniqueItems
]

{ #category : #accessing }
JsonArraySchema >> uniqueItems: aBoolean [
	uniqueItems := aBoolean
]

