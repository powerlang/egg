'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonWriter category: #JSON!
Object subclass: #JsonWriter
	instanceVariableNames: 'stream mappings indent visited sort'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonWriter commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
addMappingsFrom: aJsonMappingRegistry
	mappings addMappingsFrom: aJsonMappingRegistry
! !

!JsonWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
codeForChar: ch
	| i code |
	('\"/' includes: ch) ifTrue: [^String with: $\ with: ch].
	ch = Bs ifTrue: [^'\b'].
	ch = Ff ifTrue: [^'\f'].
	ch = Lf ifTrue: [^'\n'].
	ch = Cr ifTrue: [^'\r'].
	ch = Tab ifTrue: [^'\t'].
	i := ch asInteger.
	i < 0x20 ifTrue: [
		code := i printPaddedWith: $0 to: 2 base: 16.
		^'\u00' , code].
	^i < 128 ifTrue: [ch] ifFalse: [ch utf8 asString]
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
contents
	^stream contents
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
cr
	stream cr; tab: indent
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
crtab
	self cr; tab
! !

!JsonWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
indent: anInteger
	indent := anInteger.
	stream tab: indent
! !

!JsonWriter methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	mappings := JsonMappingRegistry new.
	indent := 0.
	sort := false
! !

!JsonWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
isBasic: anObject
	anObject isUndefinedValue ifTrue: [^true].
	anObject isNumber ifTrue: [^true].
	anObject isString ifTrue: [^true].
	anObject isBoolean ifTrue: [^true].
	anObject isDate ifTrue: [^true].
	anObject isTimestamp ifTrue: [^true].
	^false
! !

!JsonWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
jsonObjectFrom: anObject
	anObject isJsonObject ifTrue: [^anObject].
	^(self mappingFor: anObject)
		ifNil: [JsonSerializer new mappings: mappings; jsonObjectFrom: anObject]
		ifNotNil: [:mapping | mapping jsonObjectFrom: anObject]
! !

!JsonWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingFor: anObject
	mappings isNil ifTrue: [^anObject class defaultMapping].
	^mappings mappingFor: anObject
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
nextWrite: aString
	aString isCharacter ifTrue: [stream nextPut: aString] ifFalse: [
		self DENY: aString isWideString.
		stream nextPutAll: aString]
! !

!JsonWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
on: aStream
	stream := aStream.
	indent := 0! !

!JsonWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
registry: aJsonMappingRegistry
	mappings := aJsonMappingRegistry
! !

!JsonWriter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
reset
	stream reset.
	indent := 0.
	visited := nil
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
return
	indent := indent - 1.
	self cr
! !

!JsonWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
sortKeys: aBoolean
	sort := aBoolean
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
space
	stream space
! !

!JsonWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
tab
	indent := indent + 1.
	stream tab
! !

!JsonWriter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject
	visited isNil ifTrue: [visited := IdentitySet new].
	anObject isNil ifTrue: [^self writeNull].
	anObject isNumber ifTrue: [^self writeNumber: anObject].
	anObject isString ifTrue: [^self writeString: anObject].
	anObject isBoolean ifTrue: [^self writeBoolean: anObject].
	anObject isDate ifTrue: [^self writeDate: anObject].
	anObject isTimestamp ifTrue: [^self writeTimestamp: anObject].
	anObject isFilename ifTrue: [^self writeFilename: anObject].
	anObject isExternalMemory ifTrue: [^self writeMemory: anObject].
	(visited includes: anObject) ifTrue: [^self writeVisitedObject: anObject].
	visited add: anObject.
	[
		anObject isDictionary ifTrue: [^self writeDictionary: anObject].
		anObject isArray ifTrue: [^self writeArray: anObject].
		anObject isCollection ifTrue: [^self writeArray: anObject asArray].
		self writeObject: anObject]
		ensure: [visited remove: anObject]
! !

!JsonWriter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject on: aStream
	self on: aStream; reset; write: anObject
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeArray: anArray
	self writeOperator: $[.
	anArray notEmpty ifTrue: [
		self crtab.
		anArray
			do: [:object | self write: object]
			separatedBy: [self writeOperator: $,; cr].
		self return].
	self writeOperator: $]
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeBoolean: aBoolean
	self nextWrite: aBoolean printString
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeDate: aDate
	self writeOperator: $".
	aDate printIso8601On: stream.
	self writeOperator: $"! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeDictionary: aDictionary
	| keys |
	self writeOperator: ${.
	aDictionary keys size > 1 ifTrue: [self crtab].
	keys := aDictionary keys.
	sort ifTrue: [keys := keys asArray sort].
	keys
		do: [:key | | value |
			value := aDictionary at: key.
			self
				writeKey: key;
				writeOperator: $:;
				space;
				write: value]
		separatedBy: [self writeOperator: $,; cr].
	aDictionary keys size > 1 ifTrue: [self return].
	self writeOperator: $}! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeFilename: aFilename
	self writeString: aFilename asString
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeKey: aString
	self writeString: aString
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeMemory: anExternalMemory
	self writeArray: anExternalMemory bytes
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeNull
	self nextWrite: 'null'
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeNumber: aNumber
	| number |
	aNumber isNaN ifTrue: [^self write: aNumber asString].
	aNumber isInfinite ifTrue: [^self write: aNumber asString].
	number := aNumber isFraction ifTrue: [aNumber asFloat] ifFalse: [aNumber].
	self nextWrite: number storeString
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeObject: anObject
	| json |
	json := self jsonObjectFrom: anObject.
	self write: json
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeOperator: aCharacter
	self nextWrite: aCharacter
! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeString: aString
	self writeOperator: $".
	aString do: [:ch | | code |
		code := self codeForChar: ch.
		self nextWrite: code].
	self writeOperator: $"! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeTimestamp: aTimestamp
	stream nextPut: $".
	aTimestamp printIso8601On: stream.
	stream nextPut: $"! !

!JsonWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeVisitedObject: anObject
	| d |
	self error: 'Recursive'.
	d := Dictionary new.
	d at: 'Class' put: anObject class name.
	d at: 'Already Visited' put: true.
	anObject class allInstVarNames do: [:key | | ivar |
		ivar := anObject instVarNamed: key.
		(self isBasic: ivar) ifTrue: [ivar d at: key put: ivar]].
	self writeDictionary: d
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonWriter class' category: #JSON!
JsonWriter class
	instanceVariableNames: ''!

!JsonWriter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
jsonObjectFrom: anObject
	^self new jsonObjectFrom: anObject
! !

!JsonWriter class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initializePools
	self addNamespace: Character namedCharacters
! !

!JsonWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
on: aStream
	^self new on: aStream
! !

!JsonWriter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject
	| stream writer |
	stream := '' writeStream.
	writer := self write: anObject on: stream.
	^String fromUTF8: writer contents
! !

!JsonWriter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject indent: anInteger
	| stream writer |
	stream := '' writeStream.
	writer := self write: anObject on: stream indent: anInteger.
	^String fromUTF8: writer contents
! !

!JsonWriter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject on: aStream
	^self new on: aStream; write: anObject
! !

!JsonWriter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject on: aStream indent: anInteger
	^self new
		on: aStream;
		indent: anInteger;
		write: anObject
! !

!JsonWriter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject registry: aJsonMappingRegistry
	| stream writer |
	stream := '' writeStream.
	writer := self new.
	writer
		on: stream;
		registry: aJsonMappingRegistry;
		write: anObject.
	^String fromUTF8: writer contents
! !


JsonWriter initialize!

