"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonWriter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'mappings',
		'indent',
		'visited',
		'sort'
	],
	#category : #JSON
}

{ #category : #services }
JsonWriter class >> jsonObjectFrom: anObject [
	^self new jsonObjectFrom: anObject
]

{ #category : #'initialization' }
JsonWriter class >> initializePools [
	self addNamespace: Character namedCharacters
]

{ #category : #'instance creation' }
JsonWriter class >> on: aStream [
	^self new on: aStream
]

{ #category : #services }
JsonWriter class >> write: anObject [
	| stream writer |
	stream := '' writeStream.
	writer := self write: anObject on: stream.
	^String fromUTF8: writer contents
]

{ #category : #services }
JsonWriter class >> write: anObject indent: anInteger [
	| stream writer |
	stream := '' writeStream.
	writer := self write: anObject on: stream indent: anInteger.
	^String fromUTF8: writer contents
]

{ #category : #services }
JsonWriter class >> write: anObject on: aStream [
	^self new on: aStream; write: anObject
]

{ #category : #services }
JsonWriter class >> write: anObject on: aStream indent: anInteger [
	^self new
		on: aStream;
		indent: anInteger;
		write: anObject
]

{ #category : #services }
JsonWriter class >> write: anObject registry: aJsonMappingRegistry [
	| stream writer |
	stream := '' writeStream.
	writer := self new.
	writer
		on: stream;
		registry: aJsonMappingRegistry;
		write: anObject.
	^String fromUTF8: writer contents
]

{ #category : #accessing }
JsonWriter >> addMappingsFrom: aJsonMappingRegistry [
	mappings addMappingsFrom: aJsonMappingRegistry
]

{ #category : #private }
JsonWriter >> codeForChar: ch [
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
]

{ #category : #writing }
JsonWriter >> contents [
	^stream contents
]

{ #category : #writing }
JsonWriter >> cr [
	stream cr; tab: indent
]

{ #category : #writing }
JsonWriter >> crtab [
	self cr; tab
]

{ #category : #accessing }
JsonWriter >> indent: anInteger [
	indent := anInteger.
	stream tab: indent
]

{ #category : #initialization }
JsonWriter >> initialize [
	super initialize.
	mappings := JsonMappingRegistry new.
	indent := 0.
	sort := false
]

{ #category : #private }
JsonWriter >> isBasic: anObject [
	anObject isUndefinedValue ifTrue: [^true].
	anObject isNumber ifTrue: [^true].
	anObject isString ifTrue: [^true].
	anObject isBoolean ifTrue: [^true].
	anObject isDate ifTrue: [^true].
	anObject isTimestamp ifTrue: [^true].
	^false
]

{ #category : #private }
JsonWriter >> jsonObjectFrom: anObject [
	anObject isJsonObject ifTrue: [^anObject].
	^(self mappingFor: anObject)
		ifNil: [JsonSerializer new mappings: mappings; jsonObjectFrom: anObject]
		ifNotNil: [:mapping | mapping jsonObjectFrom: anObject]
]

{ #category : #private }
JsonWriter >> mappingFor: anObject [
	mappings isNil ifTrue: [^anObject class defaultMapping].
	^mappings mappingFor: anObject
]

{ #category : #writing }
JsonWriter >> nextWrite: aString [
	aString isCharacter ifTrue: [stream nextPut: aString] ifFalse: [
		self DENY: aString isWideString.
		stream nextPutAll: aString]
]

{ #category : #accessing }
JsonWriter >> on: aStream [
	stream := aStream.
	indent := 0]

{ #category : #accessing }
JsonWriter >> registry: aJsonMappingRegistry [
	mappings := aJsonMappingRegistry
]

{ #category : #services }
JsonWriter >> reset [
	stream reset.
	indent := 0.
	visited := nil
]

{ #category : #writing }
JsonWriter >> return [
	indent := indent - 1.
	self cr
]

{ #category : #accessing }
JsonWriter >> sortKeys: aBoolean [
	sort := aBoolean
]

{ #category : #writing }
JsonWriter >> space [
	stream space
]

{ #category : #accessing }
JsonWriter >> tab [
	indent := indent + 1.
	stream tab
]

{ #category : #services }
JsonWriter >> write: anObject [
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
]

{ #category : #services }
JsonWriter >> write: anObject on: aStream [
	self on: aStream; reset; write: anObject
]

{ #category : #writing }
JsonWriter >> writeArray: anArray [
	self writeOperator: $[.
	anArray notEmpty ifTrue: [
		self crtab.
		anArray
			do: [:object | self write: object]
			separatedBy: [self writeOperator: $,; cr].
		self return].
	self writeOperator: $]
]

{ #category : #writing }
JsonWriter >> writeBoolean: aBoolean [
	self nextWrite: aBoolean printString
]

{ #category : #writing }
JsonWriter >> writeDate: aDate [
	self writeOperator: $".
	aDate printIso8601On: stream.
	self writeOperator: $"]

{ #category : #writing }
JsonWriter >> writeDictionary: aDictionary [
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
	self writeOperator: $}]

{ #category : #writing }
JsonWriter >> writeFilename: aFilename [
	self writeString: aFilename asString
]

{ #category : #writing }
JsonWriter >> writeKey: aString [
	self writeString: aString
]

{ #category : #writing }
JsonWriter >> writeMemory: anExternalMemory [
	self writeArray: anExternalMemory bytes
]

{ #category : #writing }
JsonWriter >> writeNull [
	self nextWrite: 'null'
]

{ #category : #writing }
JsonWriter >> writeNumber: aNumber [
	| number |
	aNumber isNaN ifTrue: [^self write: aNumber asString].
	aNumber isInfinite ifTrue: [^self write: aNumber asString].
	number := aNumber isFraction ifTrue: [aNumber asFloat] ifFalse: [aNumber].
	self nextWrite: number storeString
]

{ #category : #writing }
JsonWriter >> writeObject: anObject [
	| json |
	json := self jsonObjectFrom: anObject.
	self write: json
]

{ #category : #writing }
JsonWriter >> writeOperator: aCharacter [
	self nextWrite: aCharacter
]

{ #category : #writing }
JsonWriter >> writeString: aString [
	self writeOperator: $".
	aString do: [:ch | | code |
		code := self codeForChar: ch.
		self nextWrite: code].
	self writeOperator: $"]

{ #category : #writing }
JsonWriter >> writeTimestamp: aTimestamp [
	stream nextPut: $".
	aTimestamp printIso8601On: stream.
	stream nextPut: $"]

{ #category : #writing }
JsonWriter >> writeVisitedObject: anObject [
	| d |
	self error: 'Recursive'.
	d := Dictionary new.
	d at: 'Class' put: anObject class name.
	d at: 'Already Visited' put: true.
	anObject class allInstVarNames do: [:key | | ivar |
		ivar := anObject instVarNamed: key.
		(self isBasic: ivar) ifTrue: [ivar d at: key put: ivar]].
	self writeDictionary: d
]

