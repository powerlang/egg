"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonAnySchema,
	#superclass : #JsonCombinedSchema,
	#category : #JSON
}

{ #category : #accessing }
JsonAnySchema class >> typeName [
	^'anyOf'
]

{ #category : #testing }
JsonAnySchema >> isAnySchema [
	^true
]

