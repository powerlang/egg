"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BooleanAdaptor,
	#superclass : #DataAdaptor,
	#category : #JSON
}

{ #category : #services }
BooleanAdaptor >> dataFrom: aBoolean [
	^aBoolean ifTrue: [1] ifFalse: [0]
]

{ #category : #services }
BooleanAdaptor >> objectFrom: anInteger [
	^anInteger asBoolean
]

