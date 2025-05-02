"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonCombinedSchema,
	#superclass : #JsonSchema,
	#instVars : [
		'schemas'
	],
	#category : #JSON
}

{ #category : #converting }
JsonCombinedSchema >> asJson [
	^JsonObject new at: self typeName put: schemas; yourself
]

{ #category : #accessing }
JsonCombinedSchema >> schemas [
	^schemas
]

{ #category : #accessing }
JsonCombinedSchema >> schemas: aCollection [
	schemas := aCollection.
	aCollection do: [:schema | schema parent: self]
]

