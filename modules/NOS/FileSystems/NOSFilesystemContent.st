"
Me and my subclasses have been copied from the Pharo versions.
FIXME: this is highly work-in-progress.
 Check what is really needed from this hierarchy
"
Class {
	#name : #NOSFilesystemContent,
	#superclass : #Object,
	#instVars : [
		'name',
		'identifier',
		'filesystem',
		'directory'
	],
	#category : #'SqueakNOS-Filesystems'
}

{ #category : #'instance creation' }
NOSFilesystemContent class >> identifier: anId filesystem:aFilesystem [
	^self named: ''
	      identifier: anId 
		filesystem: aFilesystem.
]

{ #category : #'instance creation' }
NOSFilesystemContent class >> named: aString identifier: anId filesystem: aFilesystem [ 
	^self new name: aString;
			   identifier: anId; 
			   filesystem: aFilesystem.
]

{ #category : #'instance creation' }
NOSFilesystemContent class >> named: aString identifier: anId filesystem: aFilesystem directory: aDirectory [ 
	^self new name: aString;
		identifier: anId; 
		filesystem: aFilesystem;
		directory: aDirectory.
]

{ #category : #accesing }
NOSFilesystemContent >> directory [
	^directory
]

{ #category : #accesing }
NOSFilesystemContent >> directory: aDirectory [
	directory := aDirectory
]

{ #category : #accesing }
NOSFilesystemContent >> filesystem [
	^filesystem
]

{ #category : #accesing }
NOSFilesystemContent >> filesystem: aFilesystem [
	filesystem := aFilesystem
]

{ #category : #accesing }
NOSFilesystemContent >> identifier [
	^identifier
]

{ #category : #accesing }
NOSFilesystemContent >> identifier: aClusterNumber [
	identifier := aClusterNumber
]

{ #category : #testing }
NOSFilesystemContent >> isDirectory [
	^false
]

{ #category : #testing }
NOSFilesystemContent >> isFile [
	^false
]

{ #category : #accesing }
NOSFilesystemContent >> name [
	^name
]

{ #category : #accesing }
NOSFilesystemContent >> name: aString [
	name := aString
]
