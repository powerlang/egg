"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #Path,
	#superclass : #ExternalObject,
	#category : #'Filesystem'
}

{ #category : #spec }
Path class >> at: aString [
	^self handle: (Library newPath: aString)
]

{ #category : #initializing }
Path >> / aString [
	^Path new handle: (Library pathOperatorSlash: self with: aString)
]

{ #category : #initializing }
Path >> asDirectory [
	| handle |
	handle := Library directoryFromPath: self.
	handle = 0 ifTrue: [^self error: 'operation failed'].
	^Directory new handle: handle
]

{ #category : #initializing }
Path >> createDirectory [
	^Library pathCreateDirectory: self
]

{ #category : #initializing }
Path >> exists [
	^Library pathExists: self
]

{ #category : #initializing }
Path >> name [
	^Library pathFilename: self
]

{ #category : #removing }
Path >> remove [
	^Library pathRemove: self
]

{ #category : #releasing }
Path >> remove [
	^Library pathRelease: self
]
