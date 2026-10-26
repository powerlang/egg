'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #MultiByteFilesystemFileStream category: 'SqueakNOS-Filesystems'!
MultiByteFileStream subclass: #MultiByteFilesystemFileStream
	instanceVariableNames: 'offset resize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems'!
!MultiByteFilesystemFileStream commentStamp: '<historical>' prior: 0!

I am a filesystem-aware verion of the already deprecated MultiByteFileStream. My prim* version of methods uses the filesystem instead of the vm file primitives.
!

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	^self primClose: fileID.
! !

!MultiByteFilesystemFileStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
filesystem
	^ fileID filesystem
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
for: aFile
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
	
! !

!MultiByteFilesystemFileStream methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	offset := 0.
	resize := false
! !

!MultiByteFilesystemFileStream methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
open: fileName forWrite: writeMode
	"Do nothing"
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primAtEnd: id
	^offset >= fileID size

! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primClose: id
	resize ifFalse: [^true].
	id filesystem cleanExtraSpace: id; flush.
	^true
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primFlush: id
	id filesystem flush
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primGetPosition: id
	^offset
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primRead: id into: byteArray startingAt: start count: max
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
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSetPosition: id to: anInteger
	anInteger > id size ifTrue: [self error: 'Out of bounds'].
	offset := anInteger
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSize: id
	"Answer the size of this file."
	^fileID size
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primTruncate: id to: aSize
	"Truncate this file to the given position."
	fileID filesystem updateSizeOf: fileID with: aSize
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primWrite: id from: stringOrByteArray startingAt: startIndex count: count
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
		
	
! !

!MultiByteFilesystemFileStream methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:32:25'!
readOnlyCopy
	^self copy readOnly.
! !

!MultiByteFilesystemFileStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
updateSizeAfterWriteUpTo: aNumber
	aNumber > fileID size ifTrue: [fileID filesystem updateSizeOf: fileID with: aNumber].
! !

!MultiByteFilesystemFileStream methodsFor:  'readability' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeOnly
	super readWrite.
	resize := true.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MultiByteFilesystemFileStream class' category: 'SqueakNOS-Filesystems'!
MultiByteFilesystemFileStream class
	instanceVariableNames: ''!

!MultiByteFilesystemFileStream class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
for: aFile
	^self new for: aFile.
	
! !


MultiByteFilesystemFileStream initialize!

