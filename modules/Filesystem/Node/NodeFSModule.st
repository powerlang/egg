"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #NodeFSModule,
	#superclass : #Module,
	#instVars : [
		'library'
	],
	#category : #'NodeFSModule'
}

{ #category : #spec }
NodeFSModule >> imports [
	^{}
]

{ #category : #initializing }
NodeFSModule >> newLibrary [
	^NodeFilesystemLibrary new
]
