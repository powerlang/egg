Class {
	#name : #NOSFile,
	#superclass : #NOSFilesystemContent,
	#instVars : [
		'size'
	],
	#category : #'SqueakNOS-Filesystems'
}

{ #category : #'file creation' }
NOSFile class >> named: fileName [
	"Open a file with the given name for reading and writing. If the name has no directory part, then the file will be created in the default directory. If the file already exists, its prior contents may be modified or replaced, but the file will not be truncated on close."

	^ self new named: fileName
]

{ #category : #registry }
NOSFile class >> named: aString identifier: anId filesystem: aFilesystem directory: aDirectory size: size [
	^ self new
		name: aString;
		identifier: anId;
		filesystem: aFilesystem;
		directory: aDirectory;
		size: size
]

{ #category : #'file creation' }
NOSFile class >> openAndTruncateForWriteFileNamed: aName [

	^ (self named: aName)
		delete;
		openForWrite
]

{ #category : #'file creation' }
NOSFile class >> openForReadFileNamed: aName [

	^ (self named: aName)
		openForRead
]

{ #category : #'file creation' }
NOSFile class >> openForWriteFileNamed: aName [

	^ (self named: aName) openForWrite
]

{ #category : #primitives }
NOSFile class >> primClose: id [
	"Close this file."

	<primitive: 'primitiveFileClose' module: 'FilePlugin'>
	self primitiveFailed
]

{ #category : #registry }
NOSFile class >> register: anObject [
	^self registry add: anObject
]

{ #category : #registry }
NOSFile class >> registry [
	^Registry ifNil: [Registry := WeakRegistry new]

]

{ #category : #registry }
NOSFile class >> retryWithGC: execBlock until: testBlock forFileNamed: fullName [
	"Some platforms, like Windows, will fail if we try to open a file twice.
	However, sometimes it may happen that a file was unreferenced and should be garbage-collected.
	The purpose of this method is to try to open the file, and if it fails, launch a garbage collection to try to close the unreferenced files.
	Then we will retry again to open the file"

	| blockValue foundIt |
	blockValue := execBlock value.
	(testBlock value: blockValue) ifTrue:[^blockValue].

	"Optimization: See if we have a file with the given name. Not really needed"
	foundIt := self registry keys "hold on strongly for now" 
		anySatisfy:[:file| file name sameAs: fullName].
	foundIt ifFalse:[^blockValue].

	Smalltalk garbageCollectMost.
	blockValue := execBlock value.
	(testBlock value: blockValue) ifTrue:[^blockValue].
	Smalltalk garbageCollect.
	^execBlock value.
]

{ #category : #registry }
NOSFile class >> unregister: anObject [
	^self registry remove: anObject ifAbsent:[]
]

{ #category : #'open/close' }
NOSFile >> basicOpenForWrite: writeMode [ 
	"Open the file with the given name. If writeMode is true, allow writing, otherwise open the file in read-only mode."
	| fullName |
	fullName := FilePathEncoder encode: name.
	^ self class
		retryWithGC: [ self primOpen: fullName writable: writeMode ]
		until:[ :id | id notNil ] 
		forFileNamed: fullName
]

{ #category : #'open/close' }
NOSFile >> delete [
	"We retries with GC because in some platforms open files cannot be open"
	self class
		retryWithGC: [ self primDelete: name ]
		until: [ :result | result notNil ]
		forFileNamed: name.
	self exists
		ifTrue: [ (CannotDeleteFileException new messageText: 'Could not delete file ' , name,'. Check the file is not open.') signal ].
]

{ #category : #'open/close' }
NOSFile >> exists [

	| handle |
	"We open it for read. If the returned handle is nil, the file could not be opened"
	handle := self basicOpenForWrite: false.
	handle ifNil: [^ false].
	self class primClose: handle.
	^ true
]

{ #category : #testing }
NOSFile >> isFile [
	^true
]

{ #category : #'instance creation' }
NOSFile >> name [

	^ name
]

{ #category : #'instance creation' }
NOSFile >> named: fileName [

	name := FilePathEncoder encode: fileName
]

{ #category : #'open/close' }
NOSFile >> openForAppend [

	| stream |
	stream := self openForWrite: true.
	^ stream setToEnd; yourself
]

{ #category : #'open/close' }
NOSFile >> openForRead [

	^ self openForWrite: false
]

{ #category : #'open/close' }
NOSFile >> openForWrite [

	^ self openForWrite: true
]

{ #category : #'open/close' }
NOSFile >> openForWrite: writeMode [ 
	"Open the file with the given name. If writeMode is true, allow writing, otherwise open the file in read-only mode."
	| fileHandle |
	fileHandle := self basicOpenForWrite: writeMode.
	fileHandle ifNil: [ FileException signal: 'cannot open file: ', name ].
	^ (BinaryFileStream handle: fileHandle file: self forWrite: writeMode)
		register;
		yourself
]

{ #category : #primitives }
NOSFile >> primDelete: aFileName [
	"Delete the file of the given name. 
	Return self if the primitive succeeds, nil otherwise."

	<primitive: 'primitiveFileDelete' module: 'FilePlugin'>
	^ nil
]

{ #category : #primitives }
NOSFile >> primOpen: fileName writable: writableFlag [
	"Open a file of the given name, and return the file ID obtained.
	If writableFlag is true, then
		if there is none with this name, then create one
		else prepare to overwrite the existing from the beginning
	otherwise
		if the file exists, open it read-only
		else return nil"

	<primitive: 'primitiveFileOpen' module: 'FilePlugin'>
	^ nil

]

{ #category : #printing }
NOSFile >> printOn: aStream [
	aStream
		nextPutAll: 'NOS File: ' , self name, ' (', identifier hex, ')'
]

{ #category : #services }
NOSFile >> readStream [
	| stream |
	stream := MultiByteFilesystemFileStream for: self.
	stream readOnly.
	^stream
]

{ #category : #streaming }
NOSFile >> readStreamDo: aBlock [
	| stream |
	stream := self readStream.
	^ [ aBlock value: stream ]
		ensure: [ stream close ]
]

{ #category : #services }
NOSFile >> readWriteStream [
	| stream |
	stream := MultiByteFilesystemFileStream for: self.
	^stream
]

{ #category : #accesing }
NOSFile >> size [
	^ size
]

{ #category : #accesing }
NOSFile >> size: anInteger [
	size := anInteger
]

{ #category : #registry }
NOSFile >> unregister [
	^self class unregister: self
]

{ #category : #services }
NOSFile >> writeStream [
	| stream |
	stream := MultiByteFilesystemFileStream for: self.
	stream writeOnly.
	^stream
]

{ #category : #streaming }
NOSFile >> writeStreamDo: aBlock [
	| stream |
	stream := self writeStream.
	^ [ aBlock value: stream ]
		ensure: [ stream close ]
]
