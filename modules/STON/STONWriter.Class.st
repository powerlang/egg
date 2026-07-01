'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STONWriter category: #STON!
Object subclass: #STONWriter
	instanceVariableNames: 'stream stonCharacters json indent objects'
	classVariableNames: 'STONCharacters STONSimpleSymbolCharacters'
	poolDictionaries: ''
	category: 'STON'!
!STONWriter commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!STONWriter methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:27:39'!
close
	stream isNil ifTrue: [^self].
	stream close.
	stream := nil
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
comma
	stream nextPutAll: ', '
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
cr
	stream crtab: indent
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
encodeCharacter: char
	| code encoding |
	code := char codePoint.
	(code < 127 and: [
		encoding := self stonCharacters at: code + 1.
		encoding notNil])
		ifTrue: [
			(encoding == #pass or: [json and: [char = $']])
				ifTrue: [stream nextPut: char]
				ifFalse: [stream nextPutAll: encoding]]
		ifFalse: [self escapeUnicode: code]
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
encodeKey: key value: value
	self nextPut: key.
	stream nextPutAll: ' : '.
	self nextPut: value
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
encodeList: aCollection
	stream nextPut: $[.
	aCollection notEmpty ifTrue: [
		self
			indentedDo: [
				self cr.
				aCollection
					do: [:element | self nextPut: element]
					separatedBy: [self comma; cr]];
			cr].
	stream nextPut: $]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
encodeMap: pairs
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
	stream nextPut: $}
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
encodeString: aString
	| quote |
	quote := json ifTrue: [$"] ifFalse: [$'].
	stream nextPut: quote.
	aString do: [:ch | self encodeCharacter: ch].
	stream nextPut: quote
! !

!STONWriter methodsFor:  'error handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
error: aString
	^STONWriterError signal: aString
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
escape: aCharacter with: anObject
	self
		ASSERT: anObject isString | (anObject == #pass);
		ASSERT: aCharacter codePoint < 256.
	self writeableStonCharacters at: aCharacter codePoint + 1 put: anObject
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
escapeUnicode: codePoint
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
				error: 'Character Unicode code point outside encoder range']]
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
escapeUnicode4: codePoint
	| code |
	stream nextPutAll: '\u'.
	code := codePoint printPaddedWith: $0 to: 4 base: 16.
	stream nextPutAll: code
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
indentedDo: aBlock
	indent := indent + 1.
	aBlock value.
	indent := indent - 1
! !

!STONWriter methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	stream := '' writeStream.
	stonCharacters := STONCharacters.
	indent := 0.
	json := false.
	objects := IdentityDictionary new
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSimpleSymbol: aSymbol
	aSymbol isEmpty ifTrue: [^false].
	1 to: aSymbol size do: [:i | | token |
		token := STONSimpleSymbolCharacters at: (aSymbol codeAt: i) + 1.
		token = 0 ifFalse: [^false]].
	^true
! !

!STONWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
jsonMode: boolean
	json := boolean.
	json
		ifTrue: [
			self
				escape: $' with: #pass;
				escape: $" with: '\"']
		ifFalse: [
			self
				escape: $" with: #pass;
				escape: $' with: '\''']
! !

!STONWriter methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextPut: anObject
	anObject stonOn: self
! !

!STONWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aWriteStream
	stream := aWriteStream
! !

!STONWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset
	objects removeAll
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonCharacters
	^stonCharacters ifNil: [stonCharacters := STONCharacters]
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
with: anObject do: aBlock
	| index |
	index := objects at: anObject ifAbsent: nil.
	index isNil
		ifTrue: [
			objects at: anObject put: objects size + 1.
			aBlock value]
		ifFalse: [
			json ifTrue: [^self error: 'shared reference detected'].
			self writeReference: index]
! !

!STONWriter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeableStonCharacters
	^self stonCharacters == STONCharacters
		ifTrue: [stonCharacters := stonCharacters copy]
		ifFalse: [stonCharacters]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeAssociation: anAssociation
	json ifTrue: [self error: 'wrong object class for JSON mode'].
	self encodeKey: anAssociation key value: anAssociation value
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeBoolean: boolean
	stream print: boolean
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeFloat: float
	float storeOn: stream
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeInteger: anInteger
	stream print: anInteger
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeList: aCollection
	self with: aCollection do: [self encodeList: aCollection]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeMap: aDictionary
	self with: aDictionary do: [self encodeMap: aDictionary]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeNull
	| token |
	token := json ifTrue: ['null'].
	stream print: token
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObject: anObject
	| ivars |
	ivars := anObject class allInstVarNames.
	ivars isEmpty
		ifTrue: [^self writeObject: anObject do: [self encodeMap: #()]].
	self writeObject: anObject streamMap: [:writer | 
		ivars do: [:ivar | 
			(anObject instVarNamed: ivar)
				ifNotNil: [:value | writer at: ivar asSymbol put: value]]]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObject: anObject do: aBlock
	(json
		and: [anObject class !!== Array]
		and: [anObject class !!== STON mapClass])
		ifTrue: [self error: 'wrong object class for JSON mode'].
	self with: anObject do: [| class name |
		class := anObject class.
		name := class isMetaclass ifTrue: ['Class'] ifFalse: [class name].
		stream nextPutAll: name; space.
		aBlock value]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObject: object listSingleton: element
	self writeObject: object do: [
		stream nextPut: $[.
		self nextPut: element.
		stream nextPut: $]]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObject: anObject streamMap: aBlock
	self writeObject: anObject do: [| writer |
		writer := STONMapWriter on: self.
		stream nextPut: ${.
		self indentedDo: [
			self cr.
			aBlock value: writer]; cr.
		stream nextPut: $}]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeObject: anObject streamShortList: aBlock
	self writeObject: anObject do: [| writer |
		writer := STONStreamWriter on: self.
		stream nextPut: $[.
		self indentedDo: [aBlock value: writer].
		stream nextPut: $]]
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeReference: anInteger
	stream nextPut: $@; print: anInteger
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeString: aString
	self encodeString: aString
! !

!STONWriter methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writeSymbol: aSymbol
	json ifTrue: [^self writeString: aSymbol].
	stream nextPut: $#.
	(self isSimpleSymbol: aSymbol)
		ifTrue: [stream nextPutAll: aSymbol]
		ifFalse: [self encodeString: aSymbol]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STONWriter class' category: #STON!
STONWriter class
	instanceVariableNames: 'STONCharacters STONSimpleSymbolCharacters'!

!STONWriter class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	self initializeSTONCharacters; initializeSTONSimpleSymbolCharacters
! !

!STONWriter class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeSTONCharacters
	STONCharacters := Array new: 127.
	32 to: 126 do: [:each | STONCharacters at: each + 1 put: #pass].
	STONCharacters
		at: 9 put: '\b';
		at: 10 put: '\t';
		at: 11 put: '\n';
		at: 13 put: '\f';
		at: 14 put: '\r';
		at: 40 put: '\''';
		at: 93 put: '\\'
! !

!STONWriter class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeSTONSimpleSymbolCharacters
	STONSimpleSymbolCharacters := ByteArray new: 256 withAll: 1.
	1 to: 256 do: [:code | | char |
		char := (code - 1) asCharacter.
		(self isSimpleSymbolChar: char)
			ifTrue: [STONSimpleSymbolCharacters at: code put: 0]]
! !

!STONWriter class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSimpleSymbolChar: aCharacter
	^'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_./'
		includes: aCharacter
! !

!STONWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aWriteStream
	^self new on: aWriteStream
! !


STONWriter initialize!

