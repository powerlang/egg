'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TOMLWriter category: #TOML!
Object subclass: #TOMLWriter
	instanceVariableNames: 'stream indent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TOML'!
!TOMLWriter commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!TOMLWriter methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isArrayOfTables: anObject
	(anObject isKindOf: Array) ifFalse: [
		(anObject isKindOf: OrderedCollection) ifFalse: [^false]].
	anObject isEmpty ifTrue: [^false].
	^anObject first isKindOf: OrderedDictionary
! !

!TOMLWriter methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isBareKey: aString
	aString isEmpty ifTrue: [^false].
	^aString allSatisfy: [:ch |
		ch isAlphanumeric or: [ch = $- or: [ch = $_]]]
! !

!TOMLWriter methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isTable: anObject
	^(anObject isKindOf: OrderedDictionary)
		or: [self isArrayOfTables: anObject]
! !

!TOMLWriter methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
on: aWriteStream
	stream := aWriteStream.
	indent := ''
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeArray: anArray
	stream nextPut: $[.
	anArray withIndexDo: [:elem :i |
		i > 1 ifTrue: [stream nextPutAll: ', '].
		self writeValue: elem].
	stream nextPut: $]
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeArrayOfTables: anArray path: aPath
	anArray do: [:table |
		stream nextPutAll: '[['.
		self writePath: aPath.
		stream nextPutAll: ']]'.
		stream nextPut: Character lf.
		self writeTopLevel: table path: aPath]
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
write: aDictionary
	self writeTopLevel: aDictionary path: #()
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeBasicString: aString
	stream nextPut: $".
	aString do: [:ch |
		ch = $" ifTrue: [stream nextPut: $\].
		ch = $\ ifTrue: [stream nextPut: $\].
		ch = Character lf ifTrue: [stream nextPutAll: '\n'. ^self].
		ch = Character cr ifTrue: [stream nextPutAll: '\r'. ^self].
		ch = Character tab ifTrue: [stream nextPutAll: '\t'. ^self].
		stream nextPut: ch].
	stream nextPut: $"
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeFloat: aFloat
	aFloat isInfinite
		ifTrue: [
			aFloat > 0
				ifTrue: [stream nextPutAll: 'inf']
				ifFalse: [stream nextPutAll: '-inf']]
		ifFalse: [
			aFloat isNaN
				ifTrue: [stream nextPutAll: 'nan']
				ifFalse: [stream nextPutAll: aFloat printString]]
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeInlineTable: aDictionary
	| first |
	stream nextPutAll: '{'.
	first := true.
	aDictionary keysAndValuesDo: [:k :v |
		first ifTrue: [first := false] ifFalse: [stream nextPutAll: ', '].
		self writeKeyName: k.
		stream nextPutAll: ' = '.
		self writeValue: v].
	stream nextPutAll: '}'
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeKey: aString value: anObject
	self writeKeyName: aString.
	stream nextPutAll: ' = '.
	self writeValue: anObject.
	stream nextPut: Character lf
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeKeyName: aString
	(self isBareKey: aString)
		ifTrue: [stream nextPutAll: aString]
		ifFalse: [self writeBasicString: aString]
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writePath: anArray
	anArray withIndexDo: [:key :i |
		i > 1 ifTrue: [stream nextPut: $.].
		self writeKeyName: key]
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeTableHeader: anArray
	stream nextPut: $[.
	self writePath: anArray.
	stream nextPut: $].
	stream nextPut: Character lf
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeTopLevel: aDictionary path: anArray
	| tables |
	tables := OrderedCollection new.
	aDictionary keysAndValuesDo: [:k :v |
		(self isTable: v)
			ifTrue: [tables add: k -> v]
			ifFalse: [self writeKey: k value: v]].
	tables do: [:assoc |
		| key value path |
		key := assoc key.
		value := assoc value.
		path := anArray copyWith: key.
		(self isArrayOfTables: value)
			ifTrue: [self writeArrayOfTables: value path: path]
			ifFalse: [self writeTableHeader: path.
				self writeTopLevel: value path: path]]
! !

!TOMLWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeValue: anObject
	anObject isString ifTrue: [^self writeBasicString: anObject].
	anObject = true ifTrue: [^stream nextPutAll: 'true'].
	anObject = false ifTrue: [^stream nextPutAll: 'false'].
	anObject isInteger ifTrue: [^stream nextPutAll: anObject printString].
	anObject isFloat ifTrue: [^self writeFloat: anObject].
	(anObject isKindOf: Array) ifTrue: [^self writeArray: anObject].
	(anObject isKindOf: OrderedCollection)
		ifTrue: [^self writeArray: anObject asArray].
	(anObject isKindOf: OrderedDictionary) ifTrue: [^self writeInlineTable: anObject].
	stream nextPutAll: anObject printString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TOMLWriter class' category: #TOML!
TOMLWriter class
	instanceVariableNames: ''!

!TOMLWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
on: aWriteStream
	^self new on: aWriteStream
! !

!TOMLWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
write: aDictionary
	^String streamContents: [:s |
		(self on: s) write: aDictionary]
! !


