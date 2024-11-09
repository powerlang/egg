"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FilesystemModule,
	#superclass : #Module,
	#instVars : [
		'library'
	],
	#category : #'Filesystem'
}

{ #category : #spec }
FilesystemModule >> imports [
	^{
		#FFI -> ExternalObject
	}
]

{ #category : #initializing }
FilesystemModule >> initializeWith: library [
	namespace at: #Library put: library.
]
