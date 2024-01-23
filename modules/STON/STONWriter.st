"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STONWriter, 
	#superclass : #Object, 
	#instVars : [
		'stream', 
		'stonCharacters', 
		'json', 
		'indent', 
		'objects'
	], 
	#classVars : [
		'STONCharacters', 
		'STONSimpleSymbolCharacters'
	], 
	#category : #STON
}

{#category : #'class initialization'}
STONWriter class >> initialize [
	self initializeSTONCharacters; initializeSTONSimpleSymbolCharacters]

{#category : #'class initialization'}
STONWriter class >> initializeSTONCharacters [
	STONCharacters := Array new: 127.
	32 to: 126 do: [:each | STONCharacters at: each + 1 put: #pass].
	STONCharacters
		at: 9 put: '\b';
		at: 10 put: '\t';
		at: 11 put: '\n';
		at: 13 put: '\f';
		at: 14 put: '\r';
		at: 40 put: '\''';
		at: 93 put: '\\']

{#category : #'class initialization'}
STONWriter class >> initializeSTONSimpleSymbolCharacters [
	STONSimpleSymbolCharacters := ByteArray new: 256 withAll: 1.
	1 to: 256 do: [:code | | char |
		char := (code - 1) asCharacter.
		(self isSimpleSymbolChar: char)
			ifTrue: [STONSimpleSymbolCharacters at: code put: 0]]]

{#category : #private}
STONWriter class >> isSimpleSymbolChar: aCharacter [
	^'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_./'
		includes: aCharacter]

{#category : #'instance creation'}
STONWriter class >> new [
	^super new initialize]

{#category : #'instance creation'}
STONWriter class >> on: aWriteStream [
	^self new on: aWriteStream]

{#category : #open/close}
STONWriter >> close [
	stream isNil ifTrue: [^self].
	stream close.
	stream := nil]

{#category : #private}
STONWriter >> comma [
	stream nextPutAll: ', ']

{#category : #private}
STONWriter >> cr [
	stream crtab: indent]

{#category : #private}
STONWriter >> encodeCharacter: char [
	| code encoding |
	code := char codePoint.
	(code < 127 and: [
		encoding := self stonCharacters at: code + 1.
		encoding notNil])
		ifTrue: [
			(encoding == #pass or: [json and: [char = $']])
				ifTrue: [stream nextPut: char]
				ifFalse: [stream nextPutAll: encoding]]
		ifFalse: [self escapeUnicode: code]]

{#category : #private}
STONWriter >> encodeKey: key value: value [
	self nextPut: key.
	stream nextPutAll: ' : '.
	self nextPut: value]

{#category : #writing}
STONWriter >> encodeList: aCollection [
	stream nextPut: $[.
	aCollection notEmpty ifTrue: [
		self
			indentedDo: [
				self cr.
				aCollection
					do: [:element | self nextPut: element]
					separatedBy: [self comma; cr]];
			cr].
	stream nextPut: $]]

{#category : #writing}
STONWriter >> encodeMap: pairs [
	| first single |
	stream nextPut: ${.
	pairs notEmpty ifTrue: [
		first := true.
		single := pairs size = 1.
		self indentedDo: [
			single ifFalse: [self cr].
			pairs keysAndValuesDo: [:key :value | 
				first ifTrue: [first := false] ifFalse: [
					self comma.
					single ifFalse: [self cr]].
				self encodeKey: key value: value]].
		single ifFalse: [self cr]].
	stream nextPut: $}]

{#category : #private}
STONWriter >> encodeString: aString [
	| quote |
	quote := json ifTrue: [$"] ifFalse: [$'].
	stream nextPut: quote.
	aString do: [:ch | self encodeCharacter: ch].
	stream nextPut: quote]

{#category : #'error handling'}
STONWriter >> error: aString [
	^STONWriterError signal: aString]

{#category : #private}
STONWriter >> escape: aCharacter with: anObject [
	self
		ASSERT: anObject isString | (anObject == #pass);
		ASSERT: aCharacter codePoint < 256.
	self writeableStonCharacters at: aCharacter codePoint + 1 put: anObject]

{#category : #private}
STONWriter >> escapeUnicode: codePoint [
	codePoint <= 16rFFFF ifTrue: [self escapeUnicode4: codePoint] ifFalse: [
		codePoint <= 16r10FFFF
			ifTrue: [| lead trail shifted |
				"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"
					"See https://tools.ietf.org/html/rfc7159#section-7"
					shifted := codePoint - 16r10000.
				lead := 16rD800 + (shifted // 16r400).
				trail := 16rDC00 + (shifted \\ 16r400).
				self escapeUnicode4: lead; escapeUnicode4: trail]
			ifFalse: [self
				error: 'Character Unicode code point outside encoder range']]]

{#category : #private}
STONWriter >> escapeUnicode4: codePoint [
	| code |
	stream nextPutAll: '\u'.
	code := codePoint printPaddedWith: $0 to: 4 base: 16.
	stream nextPutAll: code]

{#category : #private}
STONWriter >> indentedDo: aBlock [
	indent := indent + 1.
	aBlock value.
	indent := indent - 1]

{#category : #initialization}
STONWriter >> initialize [
	super initialize.
	stream := '' writeStream.
	stonCharacters := STONCharacters.
	indent := 0.
	json := false.
	objects := IdentityDictionary new]

{#category : #private}
STONWriter >> isSimpleSymbol: aSymbol [
	aSymbol isEmpty ifTrue: [^false].
	1 to: aSymbol size do: [:i | | token |
		token := STONSimpleSymbolCharacters at: (aSymbol codeAt: i) + 1.
		token = 0 ifFalse: [^false]].
	^true]

{#category : #accessing}
STONWriter >> jsonMode: boolean [
	json := boolean.
	json
		ifTrue: [
			self
				escape: $' with: #pass;
				escape: $" with: '\"']
		ifFalse: [
			self
				escape: $" with: #pass;
				escape: $' with: '\''']]

{#category : #public}
STONWriter >> nextPut: anObject [
	anObject stonOn: self]

{#category : #accessing}
STONWriter >> on: aWriteStream [
	stream := aWriteStream]

{#category : #accessing}
STONWriter >> reset [
	objects removeAll]

{#category : #private}
STONWriter >> stonCharacters [
	^stonCharacters ifNil: [stonCharacters := STONCharacters]]

{#category : #private}
STONWriter >> with: anObject do: aBlock [
	| index |
	index := objects at: anObject ifAbsent: nil.
	index isNil
		ifTrue: [
			objects at: anObject put: objects size + 1.
			aBlock value]
		ifFalse: [
			json ifTrue: [^self error: 'shared reference detected'].
			self writeReference: index]]

{#category : #private}
STONWriter >> writeableStonCharacters [
	^self stonCharacters == STONCharacters
		ifTrue: [stonCharacters := stonCharacters copy]
		ifFalse: [stonCharacters]]

{#category : #writing}
STONWriter >> writeAssociation: anAssociation [
	json ifTrue: [self error: 'wrong object class for JSON mode'].
	self encodeKey: anAssociation key value: anAssociation value]

{#category : #writing}
STONWriter >> writeBoolean: boolean [
	stream print: boolean]

{#category : #writing}
STONWriter >> writeFloat: float [
	float storeOn: stream]

{#category : #writing}
STONWriter >> writeInteger: anInteger [
	stream print: anInteger]

{#category : #writing}
STONWriter >> writeList: aCollection [
	self with: aCollection do: [self encodeList: aCollection]]

{#category : #writing}
STONWriter >> writeMap: aDictionary [
	self with: aDictionary do: [self encodeMap: aDictionary]]

{#category : #writing}
STONWriter >> writeNull [
	| token |
	token := json ifTrue: ['null'].
	stream print: token]

{#category : #writing}
STONWriter >> writeObject: anObject [
	| ivars |
	ivars := anObject class allInstVarNames.
	ivars isEmpty
		ifTrue: [^self writeObject: anObject do: [self encodeMap: #()]].
	self writeObject: anObject streamMap: [:writer | 
		ivars do: [:ivar | 
			(anObject instVarNamed: ivar)
				ifNotNil: [:value | writer at: ivar asSymbol put: value]]]]

{#category : #writing}
STONWriter >> writeObject: anObject do: aBlock [
	(json
		and: [anObject class !== Array]
		and: [anObject class !== STON mapClass])
		ifTrue: [self error: 'wrong object class for JSON mode'].
	self with: anObject do: [| class name |
		class := anObject class.
		name := class isMetaclass ifTrue: ['Class'] ifFalse: [class name].
		stream nextPutAll: name; space.
		aBlock value]]

{#category : #writing}
STONWriter >> writeObject: object listSingleton: element [
	self writeObject: object do: [
		stream nextPut: $[.
		self nextPut: element.
		stream nextPut: $]]]

{#category : #writing}
STONWriter >> writeObject: anObject streamMap: aBlock [
	self writeObject: anObject do: [| writer |
		writer := STONMapWriter on: self.
		stream nextPut: ${.
		self indentedDo: [
			self cr.
			aBlock value: writer]; cr.
		stream nextPut: $}]]

{#category : #writing}
STONWriter >> writeObject: anObject streamShortList: aBlock [
	self writeObject: anObject do: [| writer |
		writer := STONStreamWriter on: self.
		stream nextPut: $[.
		self indentedDo: [aBlock value: writer].
		stream nextPut: $]]]

{#category : #writing}
STONWriter >> writeReference: anInteger [
	stream nextPut: $@; print: anInteger]

{#category : #writing}
STONWriter >> writeString: aString [
	self encodeString: aString]

{#category : #writing}
STONWriter >> writeSymbol: aSymbol [
	json ifTrue: [^self writeString: aSymbol].
	stream nextPut: $#.
	(self isSimpleSymbol: aSymbol)
		ifTrue: [stream nextPutAll: aSymbol]
		ifFalse: [self encodeString: aSymbol]]

