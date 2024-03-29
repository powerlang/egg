"
    Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #JSONWriter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'objects',
		'mapping',
		'imports',
		'exports',
		'indexes',
		'closure'
	],
	#category : #'JSONWriter'
}

{ #category : #accessing }
JSONWriter >> closure: anObjectClosure [
	closure := anObjectClosure
]

{ #category : #accessing }
JSONWriter >> objects: aCollection [
	objects := aCollection
]

{ #category : #accessing }
JSONWriter >> mapping: aDictionary [
	mapping := aDictionary
]

{ #category : #accessing }
JSONWriter >> imports: anIdentityDictionary [
	imports := anIdentityDictionary
]

{ #category : #accessing }
JSONWriter >> exports: aDictionary [
	exports := aDictionary
]

{ #category : #accessing }
JSONWriter >> image [
	^stream contents
]

{ #category : #initializing }
JSONWriter >> initialize [
	indexes := IdentityDictionary new.
	stream := '' writeStream.
]

{ #category : #closure }
JSONWriter >> generateIndexes [
	| index |
	index := 0.
	objects do: [:o | indexes at: o put: index. index := index + 1].
	imports keysDo: [:o | indexes at: o put: index. index := index + 1].
	mapping keysAndValuesDo: [:obj :surrogate |
		indexes at: surrogate ifPresent: [:i | indexes at: obj put: i]].
]

{ #category : #services }
JSONWriter >> indexOf: anObject [
	| path |
	HashTable nilToken == anObject ifTrue: [^indexes at: closure nilToken].
	indexes at: anObject ifPresent: [:index | ^index].
	path := closure isDebugging ifTrue: [closure reversePathOf: anObject].
	self error: 'slot of an object not found in closure'
]

{ #category : #private }
JSONWriter >> quoted: aSymbol [
	^'"', aSymbol asString, '"'
]

{ #category : #accessing }
JSONWriter >> stream: aWriteStream [
	stream := aWriteStream
]

{ #category : #services }
JSONWriter >> write [
	self generateIndexes.
	stream nextPutAll: '{ '; crtab; nextPutAll: '"objects" : ['; crtab: 2.
	self writeObjects.
	stream crtab; nextPutAll: '],'; crtab; nextPutAll: '"imports" : ['; crtab: 2.
	self writeImports.
	stream crtab; nextPutAll: '],'; crtab; nextPutAll: '"exports" : ['; crtab: 2.
	self  writeExports.
	stream crtab; nextPutAll: ']'; cr; nextPutAll: '}'
]

{ #category : #writing }
JSONWriter >> writeExports [
	exports keys
		do: [ :name | | object index |
			object := exports at: name.
			index := self indexOf: object.
			stream
				nextPutAll: '["';
				nextPutAll: name;
				nextPutAll: '", ', index printString, ']' ]
		separatedBy: [stream nextPutAll: ', '; crtab: 2]
]

{ #category : #'*snapshotting' }
JSONWriter >> writeImportLinker: linker [
	linker ifNil: [^self].
	stream nextPutAll: ', '; nextPutAll: (self quoted: linker)
]

{ #category : #'*snapshotting' }
JSONWriter >> writeImportToken: token [
	token isString ifTrue: [^stream nextPutAll: (self quoted: token)].
	stream nextPutAll: '['.
	token
		do: [:str | stream nextPutAll: (self quoted: str)]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPutAll: ']'
]

{ #category : #writing }
JSONWriter >> writeImport: aSymbolicReference [
	stream nextPutAll: '['.
	self
		writeImportToken: aSymbolicReference token;
		writeImportLinker: aSymbolicReference linker.
	stream nextPutAll: ']'
]

{ #category : #writing }
JSONWriter >> writeImports [
	imports
		do: [ :symref | self writeImport: symref ]
		separatedBy: [stream nextPutAll: ', '; crtab: 2]
]

{ #category : #writing }
JSONWriter >> writeObject: obj [
	obj _isSmallInteger 
		ifTrue: [^stream nextPutAll: '3, ', obj printString].
	
	self writeObjectBody: obj; writeObjectHeader: obj.
]

{ #category : #writing }
JSONWriter >> writeObjectBody: obj [
	obj _isBytes
		ifTrue: [ self writeObjectBytes: obj ]
		ifFalse: [ self writeObjectSlots: obj ]
]

{ #category : #writing }
JSONWriter >> writeObjectBytes: obj [
	| current aligned |
	stream nextPutAll: '2, ['.
	(1 to: obj _size) 
		do: [:i | stream nextPutAll: (obj _byteAt: i) printString]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPutAll: ']'
]

{ #category : #accessing }
JSONWriter >> writeObjectHeader: obj [
	| behavior |
	behavior := self indexOf: obj behavior.
	stream 
		nextPutAll: ', [', behavior printString, ', ';
		nextPutAll: obj _hash printString;
"		nextPutAll: 'flags : ', obj _flags printString;"
		nextPutAll: ']'.
]

{ #category : #accessing }
JSONWriter >> writeObjectSlots: obj [
	stream nextPutAll: '1, ['.
	(1 to: obj _pointersSize)
		do: [ :i | | slot index | 
			slot := obj _basicAt: i.
			index := self indexOf: slot.
			stream nextPutAll: index printString ]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPutAll: ']'
]

{ #category : #accessing }
JSONWriter >> writeObjects [
	objects
		do: [ :obj | 
			stream nextPut: $[.
			self writeObject: obj.
			stream nextPut: $] ]
		separatedBy: [stream nextPut: $,; crtab: 2]
]

{ #category : #writing }
JSONWriter >> writeTo: aStream [
	self stream: aStream; write.
]

{ #category : #writing }
JSONWriter >> writeToFile: filename [
	filename binaryWriteStreamDo: [ :s | self writeTo: byteStream ]
]

