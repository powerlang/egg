'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RemoteMultiByteFileStream category: 'SqueakNOS-FileSupport'!
MultiByteFileStream subclass: #RemoteMultiByteFileStream
	instanceVariableNames: 'channel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-FileSupport'!
!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
atEnd
	^ self channel remotePerform: #atEnd
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
basicNext
	^ self channel remotePerform: #basicNext
! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
channel
	channel
		ifNil: [channel := RemoteObjectChannel for: self using: 'MultiByteFileStream new'].
	^ channel
! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
channel: aStream
	channel := aStream
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	^ self channel remotePerform: #close
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
closed
	^ self channel remotePerform: #closed
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
ensureOpen
	^ self channel remotePerform: #ensureOpen
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
finalize
	^ self channel remotePerform: #finalize
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
flush
	^ self channel remotePerform: #flush
! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger
	^ self channel remotePerform: #next: with: anInteger
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger putAll: aString startingAt: startIndex
	^ self nextPutAll: (aString copyFrom: startIndex to: startIndex + anInteger)
! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextChunk
	^ self channel remotePerform: #nextChunk
! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextChunkText
	^ self channel remotePerform: #nextChunkText
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: char
	^ self channel remotePerform: #nextPut: with: char
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPutAll: aString
	^ self channel remotePerform: #nextPutAll: with: aString
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
open: fileName forWrite: writableFlag
	name := fileName.
	rwmode := writableFlag.
	^ self channel remotePerform: #open:forWrite: with: fileName with: writableFlag

! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
peek
	^ self channel remotePerform: #peek
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
position
	^ self channel remotePerform: #position
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
position: pos
	^ self channel remotePerform: #position: with: pos
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primAtEnd: id
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primClose: id
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primCloseNoError: id
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primFlush: id
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primGetPosition: id
	^ self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primOpen: fileName writable: writableFlag
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primRead: id into: byteArray startingAt: startIndex count: count
	"The main problem with this primitive is that it replaces the contents of the string,
	and that is not reflected in the answer. We'll need to hack something if needed"
	self shouldNotImplement.
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSetPosition: id to: anInteger
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSize: id
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSizeNoError: id
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primTruncate: id to: anInteger
	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primWrite: id from: stringOrByteArray startingAt: startIndex count: count

	self shouldNotImplement
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
reopen
	^ self channel remotePerform: #reopen
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ self channel remotePerform: #size
! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
skipSeparators
	^ self channel remotePerform: #skipSeparators
! !

!RemoteMultiByteFileStream methodsFor:  'remote file compatibility' stamp: 'KenD 28/Jun/2026 13:32:25'!
truncate: pos
	^ self channel remotePerform: #truncate: with: pos
! !

!RemoteMultiByteFileStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
upTo: aCharacter
	^ self channel remotePerform: #upTo: with: aCharacter
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RemoteMultiByteFileStream class' category: 'SqueakNOS-FileSupport'!
RemoteMultiByteFileStream class
	instanceVariableNames: ''!


