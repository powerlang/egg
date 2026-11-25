'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #JSONWriter category: #JSONWriter!
Writer subclass: #JSONWriter
	instanceVariableNames: 'indexes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSONWriter'!
!JSONWriter commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
!

!JSONWriter methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	indexes := IdentityDictionary new.
! !

!JSONWriter methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
generateIndexes
	| index |
	index := 0.
	objects do: [:o | indexes at: o put: index. index := index + 1].
	imports keysDo: [:o | indexes at: o put: index. index := index + 1].
	mapping keysAndValuesDo: [:obj :surrogate |
		indexes at: surrogate ifPresent: [:i | indexes at: obj put: i]].
! !

!JSONWriter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
indexOf: anObject
	| path |
	HashTable nilToken == anObject ifTrue: [^indexes at: closure nilToken].
	indexes at: anObject ifPresent: [:index | ^index].
	path := closure isDebugging ifTrue: [closure reversePathOf: anObject].
	self error: 'slot of an object not found in closure'
! !

!JSONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
quoted: aSymbol
	^'"', aSymbol asString, '"'
! !

!JSONWriter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
write
	self generateIndexes.
	stream nextPutAll: '{ '; crtab; nextPutAll: '"objects" : ['; crtab: 2.
	self writeObjects.
	stream crtab; nextPutAll: '],'; crtab; nextPutAll: '"imports" : ['; crtab: 2.
	self writeImports.
	stream crtab; nextPutAll: '],'; crtab; nextPutAll: '"exports" : ['; crtab: 2.
	self  writeExports.
	stream crtab; nextPutAll: ']'; cr; nextPutAll: '}'
! !

!JSONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeExports
	exports keys
		do: [ :name | | object index |
			object := exports at: name.
			index := self indexOf: object.
			stream
				nextPutAll: '["';
				nextPutAll: name;
				nextPutAll: '", ', index printString, ']' ]
		separatedBy: [stream nextPutAll: ', '; crtab: 2]
! !

!JSONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImport: aSymbolicReference
	| elements |
	stream
		nextPutAll: '[';
		nextPutAll: (self quoted: aSymbolicReference linker).

	aSymbolicReference token ifNotNil: [:token |
		elements := token isString ifTrue: [{token}] ifFalse: [token].
		elements do: [:str |
			stream
				nextPutAll: ', ';
				nextPutAll: (self quoted: str)]].
	stream nextPutAll: ']'
! !

!JSONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeImports
	imports
		do: [ :symref | self writeImport: symref ]
		separatedBy: [stream nextPutAll: ', '; crtab: 2]
! !

!JSONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObject: obj
	obj _isSmallInteger 
		ifTrue: [^stream nextPutAll: '3, ', obj printString].
	
	self writeObjectBody: obj; writeObjectHeader: obj.
! !

!JSONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectBody: obj
	obj _isBytes
		ifTrue: [ self writeObjectBytes: obj ]
		ifFalse: [ self writeObjectSlots: obj ]
! !

!JSONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectBytes: obj
	| current aligned |
	stream nextPutAll: '2, ['.
	(1 to: obj _size) 
		do: [:i | stream nextPutAll: (obj _byteAt: i) printString]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPutAll: ']'
! !

!JSONWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectHeader: obj
	| behavior |
	behavior := self indexOf: obj behavior.
	stream 
		nextPutAll: ', [', behavior printString, ', ';
		nextPutAll: obj _hash printString;
"		nextPutAll: 'flags : ', obj _flags printString;"
		nextPutAll: ']'.
! !

!JSONWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjectSlots: obj
	stream nextPutAll: '1, ['.
	(1 to: obj _pointersSize)
		do: [ :i | | slot index | 
			slot := obj _basicAt: i.
			index := self indexOf: slot.
			stream nextPutAll: index printString ]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPutAll: ']'
! !

!JSONWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObjects
	objects
		do: [ :obj | 
			stream nextPut: $[.
			self writeObject: obj.
			stream nextPut: $] ]
		separatedBy: [stream nextPut: $,; crtab: 2]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JSONWriter class' category: #JSONWriter!
JSONWriter class
	instanceVariableNames: ''!


JSONWriter initialize!

