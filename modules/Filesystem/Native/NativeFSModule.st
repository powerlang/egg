"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #NativeFSModule,
	#superclass : #Module,
	#instVars : [
		'library'
	],
	#category : #'NativeFSModule'
}

{ #category : #spec }
NativeFSModule >> imports [
	^{
		#FFI -> ExternalLibrary
	}
]

{ #category : #initializing }
NativeFSModule >> newLibrary [
	^CPPFilesystemLibrary new open
]
