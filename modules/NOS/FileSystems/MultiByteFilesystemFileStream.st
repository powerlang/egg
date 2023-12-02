"
I am a filesystem-aware verion of the already deprecated MultiByteFileStream. My prim* version of methods uses the filesystem instead of the vm file primitives.
"
Class {
	#name : #MultiByteFilesystemFileStream,
	#superclass : #MultiByteFileStream,
	#instVars : [
		'offset',
		'resize'
	],
	#category : 'SqueakNOS-Filesystems'
}

{ #category : #'instance creation' }
MultiByteFilesystemFileStream class >> for: aFile [
	^self new for: aFile.
	
]

{ #category : #private }
MultiByteFilesystemFileStream >> close [
	^self primClose: fileID.
]

{ #category : #accessing }
MultiByteFilesystemFileStream >> filesystem [
	^ fileID filesystem
]

{ #category : #private }
MultiByteFilesystemFileStream >> for: aFile [
	fileID := aFile.
	name := aFile name.
	self register.
	offset := 0.
	rwmode := true.
	resize := false.
	buffer1 := String new: 1.
	self enableReadBuffering.
	converter := UTF8TextConverter new.
	self detectLineEndConvention.
	
]

{ #category : #'initialize-release' }
MultiByteFilesystemFileStream >> initialize [
	super initialize.
	offset := 0.
	resize := false
]

{ #category : #'open/close' }
MultiByteFilesystemFileStream >> open: fileName forWrite: writeMode [
	"Do nothing"
]

{ #category : #private }
MultiByteFilesystemFileStream >> primAtEnd: id [
	^offset >= fileID size

]

{ #category : #private }
MultiByteFilesystemFileStream >> primClose: id [
	resize ifFalse: [^true].
	id filesystem cleanExtraSpace: id; flush.
	^true
]

{ #category : #private }
MultiByteFilesystemFileStream >> primFlush: id [
	id filesystem flush
]

{ #category : #private }
MultiByteFilesystemFileStream >> primGetPosition: id [
	^offset
]

{ #category : #private }
MultiByteFilesystemFileStream >> primRead: id into: byteArray startingAt: start count: max [
	"Read up to count bytes of data from this file into the given string or byte array starting at the given index. Answer the number of bytes actually read."
	| count contents read |
	count := max min: self size - offset.
	contents := id filesystem
				contentsFor: id
				startingAt: offset
				count: count.
	read := contents size.
	byteArray replaceFrom: start to: start + read - 1 with: contents.		
	self primSetPosition: id to: (self primGetPosition: id) + read.				
	^read
]

{ #category : #private }
MultiByteFilesystemFileStream >> primSetPosition: id to: anInteger [
	anInteger > id size ifTrue: [self error: 'Out of bounds'].
	offset := anInteger
]

{ #category : #private }
MultiByteFilesystemFileStream >> primSize: id [
	"Answer the size of this file."
	^fileID size
]

{ #category : #private }
MultiByteFilesystemFileStream >> primTruncate: id to: aSize [
	"Truncate this file to the given position."
	fileID filesystem updateSizeOf: fileID with: aSize
]

{ #category : #private }
MultiByteFilesystemFileStream >> primWrite: id from: stringOrByteArray startingAt: startIndex count: count [
	"Write count bytes onto this file from the given string or byte array starting at the given index. Answer the number of bytes written."
	| bytesWritten pos |
	pos := self primGetPosition: id.
	bytesWritten := id filesystem
		writeOn: id
		startingAt: pos
		contents: stringOrByteArray
		startingAt: 1
		count: count.
	self updateSizeAfterWriteUpTo: pos + bytesWritten.	
	self primSetPosition: id to: pos + bytesWritten.
	^bytesWritten	
		
	
]

{ #category : #'open/close' }
MultiByteFilesystemFileStream >> readOnlyCopy [	
	^self copy readOnly.
]

{ #category : #private }
MultiByteFilesystemFileStream >> updateSizeAfterWriteUpTo: aNumber [
	aNumber > fileID size ifTrue: [fileID filesystem updateSizeOf: fileID with: aNumber].
]

{ #category : #readability }
MultiByteFilesystemFileStream >> writeOnly [
	super readWrite.
	resize := true.
]
