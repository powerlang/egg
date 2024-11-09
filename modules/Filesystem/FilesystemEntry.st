"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FilesystemEntry,
	#superclass : #ExternalObject,
	#category : #'Filesystem'
}

{ #category : #spec }
FilesystemEntry class >> at: aString [
	^self new handle: (Library pathNew: aString)
]

{ #category : #initializing }
FilesystemEntry >> basicPath [
	^self subclassResponsibility
]

{ #category : #initializing }
FilesystemEntry >> directory [
	^self parent asDirectory
]


{ #category : #initializing }
File >> exists [
	^self path exists
]

{ #category : #initializing }
FilesystemEntry >> path [
	^Path new handle: self basicPath
]

{ #category : #initializing }
FilesystemEntry >> parent [
	^Path new handle: (Library pathParent: self)
]

{ #category : #initializing }
FilesystemEntry >> remove [
	^self path remove
]
