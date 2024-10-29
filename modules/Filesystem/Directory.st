"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #Directory,
	#superclass : #FilesystemEntry,
	#category : #'Filesystem'
}


{ #category : #initializing }
Directory >> / aString [
	| handle |
	handle := Library pathOperatorSlash: self path with: aString.
	^Directory new handle: handle
]

{ #category : #initializing }
Directory >> basicPath [
	^Library directoryPath: self
]

{ #category : #initializing }
Directory >> create [
	Library pathCreateDirectory: self path
]