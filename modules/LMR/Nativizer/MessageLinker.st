Class {
	#name : #MessageLinker,
	#superclass : #Object,
	#instVars : [
		'filter'
	],
	#category : #Nativization
}

{ #category : #testing }
MessageLinker >> canInline: aSymbol [
	filter ifNil: [ ^true ].
	filter == aSymbol ifTrue: [ ^true ].
	^(filter includes: aSymbol)
]

{ #category : #testing }
MessageLinker >> filter: anObject [
	filter := anObject.
	filter isCollection ifTrue: [filter := filter asIdentitySet]
]
