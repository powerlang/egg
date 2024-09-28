"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that represents a dynamic library such as an so, a dll or a dylib
"

Class {
	#name : #ExternalLibrary,
	#superclass : #Object,
	#instVars : [
		'handle'
	],
	#category : #FFI
}

{ #category : #accessing }
ExternalLibrary >> filename [
	^self loader libraryFilename: self
]

{ #category : #accessing }
ExternalLibrary >> loader [
	^self module loader
]

{ #category : #accessing }
ExternalLibrary >> open [
	self loader open: self
]
