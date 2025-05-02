"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonNotSchema,
	#superclass : #JsonSchema,
	#instVars : [
		'schema'
	],
	#category : #JSON
}

{ #category : #converting }
JsonNotSchema >> asJson [
	^JsonObject new at: self typeName put: schema; yourself
]

{ #category : #testing }
JsonNotSchema >> isNotSchema [
	^true
]

{ #category : #accessing }
JsonNotSchema >> schema [
	^schema
]

{ #category : #accessing }
JsonNotSchema >> schema: aJsonSchema [
	schema := aJsonSchema.
	aJsonSchema parent: self
]

