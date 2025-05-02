"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IdAdaptor,
	#superclass : #DataAdaptor,
	#instVars : [
		'selector'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
IdAdaptor class >> forName [
	^self new selector: #name
]

{ #category : #services }
IdAdaptor >> dataFrom: anObject [
	anObject isNil ifTrue: [^nil].
	anObject isInteger ifTrue: [^anObject].
	anObject isString ifTrue: [^anObject].
	^selector evaluateWith: anObject
]

{ #category : #initialization }
IdAdaptor >> initialize [
	super initialize.
	selector := #id
]

{ #category : #services }
IdAdaptor >> objectFrom: anInteger [
	^anInteger
]

{ #category : #accessing }
IdAdaptor >> selector: aSymbol [
	selector := aSymbol
]

