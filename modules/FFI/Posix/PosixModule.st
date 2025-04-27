"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #PosixModule,
	#superclass : #Module,
	#category : #FFI
}

{ #category : #services }
PosixModule >> externalCopyOfString: aString [
	^Kernel utf8 externalCopyOf: aString
]

{ #category : #services }
PosixModule >> imports [
	^{ #FFI -> #(ExternalLibrary ExternalMemory LibraryLoader) }
]
