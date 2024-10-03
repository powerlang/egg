"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that allows loading dynamic libraries. My subclasses know
	how to do it in each platform.
"

Class {
	#name : #LibraryLoader,
	#superclass : #Object,
	#instVars : [
		''
	],
	#category : #FFI
}

{ #category : #accessing }
LibraryLoader >> open: anExternalLibrary [
	self subclassResponsibility
]

{ #category : #accessing }
LibraryLoader >> findSymbol: aSymbol in: anExternalLibrary [
	^self subclassResponsibility
]

