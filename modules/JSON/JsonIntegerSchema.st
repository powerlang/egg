"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonIntegerSchema,
	#superclass : #JsonNumberSchema,
	#category : #JSON
}

{ #category : #accessing }
JsonIntegerSchema >> defaultFormat [
	^JsonIntegerFormat new
]

{ #category : #testing }
JsonIntegerSchema >> isIntegerSchema [
	^true
]

