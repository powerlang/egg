"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #WindowsModule,
	#superclass : #Module,
	#category : #FFI
}

{ #category : #services }
WindowsModule >> externalCopyOfString: aString [
	^Kernel utf16 externalCopyOf: aString
]


{ #category : #services }
WindowsModule >> imports [
	^{ #FFI -> #(ExternalLibrary LibC LibraryLoader) }
]
