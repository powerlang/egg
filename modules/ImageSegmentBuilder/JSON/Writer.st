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
		'indexes'
	],
	#category : #'Writer'
}

{ #category : #accessing }
Writer >> objects: aCollection [
	objects := aCollection
]

{ #category : #accessing }
Writer >> mapping: aDictionary [
	mapping := aDictionary
]

{ #category : #accessing }
Writer >> imports: aCollection [
	imports := aCollection
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
	imports do: [:o | indexes at: o put: index. index := index + 1].
	mapping keysAndValuesDo: [:obj :surrogate | | i |
		i := indexes at: surrogate.
		indexes at: obj put: i]
]

{ #category : #services }
Writer >> indexOf: anObject [
	^indexes at: anObject ifAbsent: [indexes at: nil]
]

{ #category : #accessing }
Writer >> stream: aWriteStream [
	stream := aWriteStream
]

{ #category : #services }
Writer >> write [
	self generateIndexes.
	stream nextPutAll: '{ '; crtab; nextPutAll: '"objects" : ['; crtab: 2.
	self writeObjects; writeImportedObjects.
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

{ #category : #writing }
Writer >> writeImports [
	imports
		do: [ :class |
			stream 
				nextPutAll: '["';
				nextPutAll: class name;
				nextPutAll: '", "';
				nextPutAll: class module name; 
				nextPutAll: '"]' ]
		separatedBy: [stream nextPutAll: ', '; crtab: 2]
]

{ #category : #writing }
Writer >> writeImportedObjects [
	| index |
	imports size = 0 ifTrue: [^self].
	stream nextPutAll: ', '; crtab: 2.
	index := 0.
	imports
		do: [ :class |
			stream 
				nextPutAll: '[4, ';
				nextPutAll: index asString;
				nextPutAll: ']' ]
		separatedBy: [
			index := index + 1.
			stream nextPutAll: ', '; crtab: 2]
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
	objects , imports
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

