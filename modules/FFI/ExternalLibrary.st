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
ExternalLibrary class >> filename [
	^self loader libraryFilename: self
]

{ #category : #accessing }
ExternalLibrary class >> libpath [
	^''
]

{ #category : #accessing }
ExternalLibrary class >> linuxFilename [
	^'lib', self libname, '.so'
]

{ #category : #accessing }
ExternalLibrary class >> macFilename [
	^'lib', self libname, '.dylib'
]

{ #category : #accessing }
ExternalLibrary class >> windowsFilename [
	^self libname, '.dll'
]

{ #category : #accessing }
ExternalLibrary >> address [
	^handle pointerAtOffset: 0
]

{ #category : #accessing }
ExternalLibrary >> address: anInteger [
	handle pointerAtOffset: 0 put: anInteger
]

{ #category : #accessing }
ExternalLibrary >> handle [
	^handle
]

{ #category : #accessing }
ExternalLibrary >> loader [
	^ExternalLibrary module loader
]

{ #category : #accessing }
ExternalLibrary >> initialize [
	handle := ExternalHandle new
]

{ #category : #accessing }
ExternalLibrary >> open [
	self loader open: self
]
