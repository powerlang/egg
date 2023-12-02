Class {
	#name : #RemoteMultiByteFileStream,
	#superclass : #MultiByteFileStream,
	#instVars : [
		'channel'
	],
	#category : 'SqueakNOS-FileSupport'
}

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> atEnd [
	^ self channel remotePerform: #atEnd
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> basicNext [
	^ self channel remotePerform: #basicNext
]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> channel [
	channel
		ifNil: [channel := RemoteObjectChannel for: self using: 'MultiByteFileStream new'].
	^ channel
]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> channel: aStream [
	channel := aStream
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> close [
	^ self channel remotePerform: #close
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> closed [
	^ self channel remotePerform: #closed
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> ensureOpen [
	^ self channel remotePerform: #ensureOpen
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> finalize [
	^ self channel remotePerform: #finalize
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> flush [
	^ self channel remotePerform: #flush
]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> next: anInteger [
	^ self channel remotePerform: #next: with: anInteger
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> next: anInteger putAll: aString startingAt: startIndex [
	^ self nextPutAll: (aString copyFrom: startIndex to: startIndex + anInteger)
]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> nextChunk [
	^ self channel remotePerform: #nextChunk
]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> nextChunkText [
	^ self channel remotePerform: #nextChunkText
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> nextPut: char [
	^ self channel remotePerform: #nextPut: with: char
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> nextPutAll: aString [
	^ self channel remotePerform: #nextPutAll: with: aString
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> open: fileName forWrite: writableFlag [
	name := fileName.
	rwmode := writableFlag.
	^ self channel remotePerform: #open:forWrite: with: fileName with: writableFlag

]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> peek [
	^ self channel remotePerform: #peek
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> position [
	^ self channel remotePerform: #position
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> position: pos [
	^ self channel remotePerform: #position: with: pos
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primAtEnd: id [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primClose: id [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primCloseNoError: id [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primFlush: id [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primGetPosition: id [
	^ self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primOpen: fileName writable: writableFlag [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primRead: id into: byteArray startingAt: startIndex count: count [
	"The main problem with this primitive is that it replaces the contents of the string,
	and that is not reflected in the answer. We'll need to hack something if needed"
	self shouldNotImplement.
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primSetPosition: id to: anInteger [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primSize: id [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primSizeNoError: id [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primTruncate: id to: anInteger [
	self shouldNotImplement
]

{ #category : #primitives }
RemoteMultiByteFileStream >> primWrite: id from: stringOrByteArray startingAt: startIndex count: count [

	self shouldNotImplement
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> reopen [
	^ self channel remotePerform: #reopen
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> size [
	^ self channel remotePerform: #size
]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> skipSeparators [
	^ self channel remotePerform: #skipSeparators
]

{ #category : #'remote file compatibility' }
RemoteMultiByteFileStream >> truncate: pos [
	^ self channel remotePerform: #truncate: with: pos
]

{ #category : #'as yet unclassified' }
RemoteMultiByteFileStream >> upTo: aCharacter [
	^ self channel remotePerform: #upTo: with: aCharacter
]
