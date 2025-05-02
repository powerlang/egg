"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DataAdaptor,
	#superclass : #Object,
	#category : #JSON
}

{ #category : #services }
DataAdaptor >> dataFrom: anObject [
	^anObject asString
]

{ #category : #testing }
DataAdaptor >> isEntityAdaptor [
	^false
]

{ #category : #services }
DataAdaptor >> objectFrom: aString [
	^(aString conform: [:ch | ch isDigit or: [#($+ $- $.) includes: ch]])
		ifTrue: [aString asNumber]
		ifFalse: [aString]
]

