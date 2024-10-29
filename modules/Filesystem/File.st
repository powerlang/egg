"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #File,
	#superclass : #FilesystemEntry,
	#category : #'Filesystem'
}

{ #category : #initializing }
File >> / aString [
	self error: 'invalid operation'
]

{ #category : #initializing }
File >> basicPath [
	self error
]
