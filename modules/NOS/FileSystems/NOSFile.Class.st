'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NOSFile category: 'SqueakNOS-Filesystems'!
NOSFilesystemContent subclass: #NOSFile
	instanceVariableNames: 'size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems'!
!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
basicOpenForWrite: writeMode
	"Open the file with the given name. If writeMode is true, allow writing, otherwise open the file in read-only mode."
	| fullName |
	fullName := FilePathEncoder encode: name.
	^ self class
		retryWithGC: [ self primOpen: fullName writable: writeMode ]
		until:[ :id | id notNil ] 
		forFileNamed: fullName
! !

!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents
	^self readStream contents

! !

!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
delete
	"We retries with GC because in some platforms open files cannot be open"
	self class
		retryWithGC: [ self primDelete: name ]
		until: [ :result | result notNil ]
		forFileNamed: name.
	self exists
		ifTrue: [ (CannotDeleteFileException new messageText: 'Could not delete file ' , name,'. Check the file is not open.') signal ].
! !

!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
exists

	| handle |
	"We open it for read. If the returned handle is nil, the file could not be opened"
	handle := self basicOpenForWrite: false.
	handle ifNil: [^ false].
	self class primClose: handle.
	^ true
! !

!NOSFile methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isFile
	^true
! !

!NOSFile methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
name

	^ name
! !

!NOSFile methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
named: fileName

	name := FilePathEncoder encode: fileName
! !

!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
openForAppend

	| stream |
	stream := self openForWrite: true.
	^ stream setToEnd; yourself
! !

!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
openForRead

	^ self openForWrite: false
! !

!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
openForWrite

	^ self openForWrite: true
! !

!NOSFile methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
openForWrite: writeMode
	"Open the file with the given name. If writeMode is true, allow writing, otherwise open the file in read-only mode."
	| fileHandle |
	fileHandle := self basicOpenForWrite: writeMode.
	fileHandle ifNil: [ FileException signal: 'cannot open file: ', name ].
	^ self readWriteStream 
! !

!NOSFile methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primDelete: aFileName
	"Delete the file of the given name. 
	Return self if the primitive succeeds, nil otherwise."

	<primitive: 'primitiveFileDelete' module: 'FilePlugin'>
	^ nil
! !

!NOSFile methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primOpen: fileName writable: writableFlag
	^self
! !

!NOSFile methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream
		nextPutAll: 'NOS File: ' , self name, ' (', identifier hex, ')'
! !

!NOSFile methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
readStream
	| stream |
	stream := MultiByteFilesystemFileStream for: self.
	stream readOnly.
	^stream
! !

!NOSFile methodsFor:  'streaming' stamp: 'KenD 28/Jun/2026 13:32:25'!
readStreamDo: aBlock
	| stream |
	stream := self readStream.
	^ [ aBlock value: stream ]
		ensure: [ stream close ]
! !

!NOSFile methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
readWriteStream
	| stream |
	stream := MultiByteFilesystemFileStream for: self.
	^stream
! !

!NOSFile methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ size
! !

!NOSFile methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: anInteger
	size := anInteger
! !

!NOSFile methodsFor:  'registry' stamp: 'KenD 28/Jun/2026 13:32:25'!
unregister
	^self class unregister: self
! !

!NOSFile methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeStream
	| stream |
	stream := MultiByteFilesystemFileStream for: self.
	stream writeOnly.
	^stream
! !

!NOSFile methodsFor:  'streaming' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeStreamDo: aBlock
	| stream |
	stream := self writeStream.
	^ [ aBlock value: stream ]
		ensure: [ stream close ]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NOSFile class' category: 'SqueakNOS-Filesystems'!
NOSFile class
	instanceVariableNames: ''!

!NOSFile class methodsFor:  'file creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
named: fileName
	"Open a file with the given name for reading and writing. If the name has no directory part, then the file will be created in the default directory. If the file already exists, its prior contents may be modified or replaced, but the file will not be truncated on close."

	^ self new named: fileName
! !

!NOSFile class methodsFor:  'registry' stamp: 'KenD 28/Jun/2026 13:32:25'!
named: aString identifier: anId filesystem: aFilesystem directory: aDirectory size: size
	^ self new
		name: aString;
		identifier: anId;
		filesystem: aFilesystem;
		directory: aDirectory;
		size: size
! !

!NOSFile class methodsFor:  'file creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
openAndTruncateForWriteFileNamed: aName

	^ (self named: aName)
		delete;
		openForWrite
! !

!NOSFile class methodsFor:  'file creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
openForReadFileNamed: aName

	^ (self named: aName)
		openForRead
! !

!NOSFile class methodsFor:  'file creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
openForWriteFileNamed: aName

	^ (self named: aName) openForWrite
! !

!NOSFile class methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primClose: id
	"Close this file."

	<primitive: 'primitiveFileClose' module: 'FilePlugin'>
	self primitiveFailed
! !

!NOSFile class methodsFor:  'registry' stamp: 'KenD 28/Jun/2026 13:32:25'!
register: anObject
	^self registry add: anObject
! !

!NOSFile class methodsFor:  'registry' stamp: 'KenD 28/Jun/2026 13:32:25'!
registry
	^Registry ifNil: [Registry := WeakRegistry new]

! !

!NOSFile class methodsFor:  'registry' stamp: 'KenD 28/Jun/2026 13:32:25'!
retryWithGC: execBlock until: testBlock forFileNamed: fullName
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
! !

!NOSFile class methodsFor:  'registry' stamp: 'KenD 28/Jun/2026 13:32:25'!
unregister: anObject
	^self registry remove: anObject ifAbsent:[]
! !


