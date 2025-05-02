"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #StringAdaptor,
	#superclass : #DataAdaptor,
	#category : #JSON
}

{ #category : #services }
StringAdaptor >> objectFrom: anObject [
	| s |
	anObject isString ifFalse: [^anObject].
	s := anObject trimBlanks.
	^s isEmpty ifFalse: [s]
]

