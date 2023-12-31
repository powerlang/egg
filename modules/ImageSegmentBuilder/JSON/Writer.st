"
    Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #Writer,
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
	#category : #'Writer'
}

{ #category : #accessing }
Writer >> closure: anObjectClosure [
	closure := anObjectClosure
]

{ #category : #accessing }
Writer >> objects: aCollection [
	objects := aCollection
]

{ #category : #accessing }
Writer >> mapping: aDictionary [
	mapping := aDictionary
]

{ #category : #accessing }
Writer >> imports: anIdentityDictionary [
	imports := anIdentityDictionary
]

{ #category : #accessing }
Writer >> exports: aDictionary [
	exports := aDictionary
]

{ #category : #accessing }
Writer >> image [
	^stream contents
]

{ #category : #initializing }
Writer >> initialize [
	indexes := IdentityDictionary new.
	stream := '' writeStream.
]

{ #category : #closure }
Writer >> generateIndexes [
	| index |
	index := 0.
	objects do: [:o | indexes at: o put: index. index := index + 1].
	imports keysDo: [:o | indexes at: o put: index. index := index + 1].
	mapping keysAndValuesDo: [:obj :surrogate |
		indexes at: surrogate ifPresent: [:i | indexes at: obj put: i]].
]

{ #category : #services }
Writer >> indexOf: anObject [
	| path |
	HashTable nilToken == anObject ifTrue: [^indexes at: closure nilToken].
	indexes at: anObject ifPresent: [:index | ^index].
	path := closure isDebugging ifTrue: [closure reversePathOf: anObject].
	self error: 'slot of an object not found in closure'
]

{ #category : #private }
Writer >> quoted: aSymbol [
	^'"', aSymbol asString, '"'
]

{ #category : #accessing }
Writer >> stream: aWriteStream [
	stream := aWriteStream
]

{ #category : #services }
Writer >> write [
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
Writer >> writeExports [
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
Writer >> writeImportLinker: linker [
	linker ifNil: [^self].
	stream nextPutAll: ', '; nextPutAll: (self quoted: linker)
]

{ #category : #'*snapshotting' }
Writer >> writeImportToken: token [
	token isString ifTrue: [^stream nextPutAll: (self quoted: token)].
	stream nextPutAll: '['.
	token
		do: [:str | stream nextPutAll: (self quoted: str)]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPutAll: ']'
]

{ #category : #writing }
Writer >> writeImport: aSymbolicReference [
	stream nextPutAll: '['.
	self
		writeImportToken: aSymbolicReference token;
		writeImportLinker: aSymbolicReference linker.
	stream nextPutAll: ']'
]

{ #category : #writing }
Writer >> writeImports [
	imports
		do: [ :symref | self writeImport: symref ]
		separatedBy: [stream nextPutAll: ', '; crtab: 2]
]

{ #category : #writing }
Writer >> writeObject: obj [
	obj _isSmallInteger 
		ifTrue: [^stream nextPutAll: '3, ', obj printString].
	
	self writeObjectBody: obj; writeObjectHeader: obj.
]

{ #category : #writing }
Writer >> writeObjectBody: obj [
	obj _isBytes
		ifTrue: [ self writeObjectBytes: obj ]
		ifFalse: [ self writeObjectSlots: obj ]
]

{ #category : #writing }
Writer >> writeObjectBytes: obj [
	| current aligned |
	stream nextPutAll: '2, ['.
	(1 to: obj _size) 
		do: [:i | stream nextPutAll: (obj _byteAt: i) printString]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPutAll: ']'
]

{ #category : #accessing }
Writer >> writeObjectHeader: obj [
	| behavior |
	behavior := self indexOf: obj behavior.
	stream 
		nextPutAll: ', [', behavior printString, ', ';
		nextPutAll: obj _hash printString;
"		nextPutAll: 'flags : ', obj _flags printString;"
		nextPutAll: ']'.
]

{ #category : #accessing }
Writer >> writeObjectSlots: obj [
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
Writer >> writeObjects [
	objects
		do: [ :obj | 
			stream nextPut: $[.
			self writeObject: obj.
			stream nextPut: $] ]
		separatedBy: [stream nextPut: $,; crtab: 2]
]

{ #category : #writing }
Writer >> writeTo: aStream [
	self stream: aStream; write.
]

{ #category : #writing }
Writer >> writeToFile: filename [
	filename binaryWriteStreamDo: [ :s | self writeTo: byteStream ]
]

