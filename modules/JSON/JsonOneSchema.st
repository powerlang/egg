"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonOneSchema,
	#superclass : #JsonCombinedSchema,
	#category : #JSON
}

{ #category : #accessing }
JsonOneSchema class >> typeName [
	^'oneOf'
]

{ #category : #testing }
JsonOneSchema >> isOneSchema [
	^true
]

