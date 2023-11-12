Class {
	#name : #NOSDirectory,
	#superclass : #NOSFilesystemContent,
	#category : #'SqueakNOS-Filesystems'
}

{ #category : #quering }
NOSDirectory >> directories [
	^self filesystem directoriesFor: self
]

{ #category : #quering }
NOSDirectory >> fileExists: aString [
	^self files anySatisfy: [:file | file name asLowercase = 
		(String streamContents: [:stream | (filesystem nameFormat: aString) asFileReference gtDisplayOn: stream]) asLowercase]
]

{ #category : #services }
NOSDirectory >> fileNamed: aString [
	^self files detect: [:file | file name asLowercase = 
		(String streamContents: [:stream | (filesystem nameFormat: aString) asFileReference gtDisplayOn: stream]) asLowercase] 
]

{ #category : #quering }
NOSDirectory >> files [
	^self filesystem filesFor: self
]

{ #category : #testing }
NOSDirectory >> isDirectory [
	^true
]

{ #category : #quering }
NOSDirectory >> newFileNamed: aString [
	^self filesystem createFileNamed: aString on: self.
]

{ #category : #quering }
NOSDirectory >> printString [
	^self filesystem printStringOf: self.
]

{ #category : #services }
NOSDirectory >> readOnlyFileNamed: aString [
	^self fileNamed: aString
]

{ #category : #quering }
NOSDirectory >> removeFileNamed: aString [
	^self filesystem removeFileNamed: aString on: self.
]
