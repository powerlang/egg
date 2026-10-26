'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STONReader category: #STON!
Object subclass: #STONReader
	instanceVariableNames: 'stream objects classes unresolved stringStream references'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'STON'!
!STONReader commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!STONReader methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addElement: v of: collection
	self addElement: v of: collection at: nil
! !

!STONReader methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addElement: element of: collection at: index
	| data |
	references isNil ifTrue: [references := OrderedCollection new].
	data := index isNil
		ifTrue: [{#elem. element. collection}]
		ifFalse: [{#elem. element. collection. index}].
	references add: data
! !

!STONReader methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addReference: aSTONReference of: anObject at: anInteger
	references isNil ifTrue: [references := OrderedCollection new].
	references add: {#ref. aSTONReference index. anObject. anInteger}
! !

!STONReader methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addReferenceKey: k value: v of: dictionary
	references isNil ifTrue: [references := OrderedCollection new].
	references add: {#assoc. k. dictionary. v}
! !

!STONReader methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
atEnd
	^stream atEnd
! !

!STONReader methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:27:39'!
close
	stream isNil ifTrue: [^self].
	stream close.
	stream := nil
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
consumeWhitespace
	stream skipSeparators
! !

!STONReader methodsFor:  'error handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
error: aString
	| position |
	position := [stream position] on: MessageNotUnderstood do: [].
	^STONReaderError signal: aString streamPosition: position
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
expectChar: aCharacter
	(self matchChar: aCharacter)
		ifFalse: [self error: aCharacter asString , ' expected']
! !

!STONReader methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	objects := IdentityDictionary new.
	classes := IdentityDictionary new.
	unresolved := 0
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
isClassChar: aCharacter
	^'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
		includes: aCharacter
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSimpleSymbolChar: aCharacter
	^aCharacter isLetter or: ['0123456789-_./' includes: aCharacter]
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupClass: aString
	(Smalltalk classNamed: aString) ifNotNil: [:class | ^class].
	^classes at: aString ifAbsentPut: [
		Object allSubclasses
			detect: [:class | class isMetaclass not and: [class stonName = aString]]
			ifNone: [Error signal: aString , ' not found']]
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
match: aString do: aBlock
	(aString conform: [:ch | stream peekFor: ch]) ifTrue: [
		self consumeWhitespace.
		aBlock value]
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
matchChar: aCharacter
	^(stream peekFor: aCharacter) ifTrue: [self consumeWhitespace]; yourself
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
newReference
	| index reference |
	index := objects size + 1.
	reference := STONReference index: index.
	^objects at: index put: reference
! !

!STONReader methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
next
	| object |
	self consumeWhitespace.
	object := self parseValue.
	unresolved > 0 ifTrue: [self processUnresolved].
	unresolved = 0 ifFalse: [self error: 'Inconsistent reference resolution'].
	objects do: [:o | o stonPostReferenceResolution].
	^object
! !

!STONReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aStream
	stream := aStream
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseCharacter
	| char |
	char := stream next.
	^char = $\ ifTrue: [self parseEscapedCharacter] ifFalse: [char]
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseCharacterHex
	| value code |
	value := self parseCharacterHex4Value.
	(value < 16rD800 or: [value > 16rDBFF])
		ifTrue: [code := value]
		ifFalse: [| lead trail |
			lead := value.
			trail := self parseTrailingSurrogateHexEscape.
			code := lead - 16rD800 * 16r400 + (trail - 16rDC00).
			code := 16r10000 + code].
	^Character codePoint: code
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseCharacterHex4Value
	| value |
	value := self parseCharacterHexDigit.
	3 timesRepeat: [value := (value bitShift: 4) + self parseCharacterHexDigit].
	^value
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseCharacterHexDigit
	| digit |
	stream atEnd ifFalse: [
		digit := stream next asInteger.
		(digit between: 48 and: 57) ifTrue: [^digit - 48].
		(digit between: 65 and: 70) ifTrue: [^digit - 55].
		(digit between: 97 and: 102) ifTrue: [^digit - 87]].
	self error: 'hex-digit expected'
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseClass
	| class |
	class := self stringStreamContents: [:strm | 
		[stream atEnd not and: [self isClassChar: stream peek]]
			whileTrue: [strm nextPut: stream next]].
	self consumeWhitespace.
	^self lookupClass: class asSymbol
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseConstantDo: aBlock
	| keys values |
	keys := #('true' 'false' 'nil' 'null').
	values := #(true false nil nil).
	1 to: keys size do: [:i | | key |
		key := keys at: i.
		(stream peek = key first and: [(stream peek: key size) = key]) ifTrue: [
			stream skip: key size.
			self consumeWhitespace.
			^aBlock value: (values at: i)]]
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseEscapedCharacter
	| char |
	char := stream next.
	(#($' $" $/ $\) includes: char) ifTrue: [^char].
	char = $b ifTrue: [^Character backspace].
	char = $f ifTrue: [^Character newPage].
	char = $n ifTrue: [^Character lf].
	char = $r ifTrue: [^Character cr].
	char = $t ifTrue: [^Character tab].
	char = $u ifTrue: [^self parseCharacterHex].
	self error: 'invalid escape character \' , char asString.
	^char
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseList
	| reference refs i array |
	reference := self newReference.
	refs := OrderedCollection new.
	i := 1.
	array := STON listClass streamContents: [:strm | 
		self parseListDo: [:element | 
			strm nextPut: element.
			element isStonReference ifTrue: [refs add: {element. i}].
			i := i + 1]].
	refs do: [:ref | self addElement: ref first of: array at: ref second].
	self setReference: reference to: array.
	^array
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseListDo: aBlock
	| index |
	self expectChar: $[.
	(self matchChar: $]) ifTrue: [^self].
	index := 1.
	[stream atEnd] whileFalse: [
		aBlock cull: self parseValue cull: index.
		(self matchChar: $]) ifTrue: [^self].
		index := index + 1.
		self expectChar: $,].
	self error: 'end of list expected'
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseListSingleton
	| value |
	value := nil.
	self parseListDo: [:element :i | i = 1 ifTrue: [value := element]].
	^value
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseMap
	| map |
	map := STON mapClass new.
	self
		storeReference: map;
		parseMapDo: [:key :value | 
			map at: key put: value.
			(key isStonReference or: [value isStonReference])
				ifTrue: [self addReferenceKey: key value: value of: map]].
	^map
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseMapDo: aBlock
	self expectChar: ${.
	(self matchChar: $}) ifTrue: [^self].
	[stream atEnd] whileFalse: [| name value |
		name := self parseSimpleValue.
		self expectChar: $:.
		value := self parseValue.
		aBlock value: name value: value.
		(self matchChar: $}) ifTrue: [^self].
		self expectChar: $,].
	self error: 'end of map expected'
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseNamedInstVarsFor: anObject
	| i |
	i := 1.
	self parseMapDo: [:ivar :value | 
		anObject instVarNamed: ivar put: value.
		value isStonReference
			ifTrue: [self addReference: value of: anObject at: i].
		i := i + 1]
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseNumber
	| negated number |
	negated := stream peekFor: $-.
	number := self parseNumberInteger.
	(stream peekFor: $.) ifTrue: [number := number + self parseNumberFraction].
	((stream peekFor: $e) or: [stream peekFor: $E])
		ifTrue: [number := number * self parseNumberExponent].
	negated ifTrue: [number := number negated].
	self consumeWhitespace.
	^number
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseNumberExponent
	| number negated |
	number := 0.
	negated := stream peekFor: $-.
	negated ifFalse: [stream peekFor: $+].
	[stream atEnd not and: [stream peek isDigit]]
		whileTrue: [number := 10 * number + stream next digitValue].
	negated ifTrue: [number := number negated].
	^10 raisedTo: number
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseNumberFraction
	| number power |
	number := 0.
	power := 1.0.
	[stream atEnd not and: [stream peek isDigit]] whileTrue: [
		number := 10 * number + stream next digitValue.
		power := power * 10.0].
	^number / power
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseNumberInteger
	| number |
	number := 0.
	[stream atEnd not and: [stream peek isDigit]]
		whileTrue: [number := 10 * number + stream next digitValue].
	^number
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseObject
	| object |
	[| reference class |
		reference := self newReference.
		class := self parseClass.
		object := class fromSton: self.
		self setReference: reference to: object]
		on: Error
		do: [self error: 'Cannot resolve class named ' , object printString].
	^object
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseReference
	| index |
	self expectChar: $@.
	index := self parseNumberInteger.
	self consumeWhitespace.
	unresolved := unresolved + 1.
	^STONReference index: index
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseSimpleValue
	| char |
	stream atEnd ifFalse: [
		char := stream peek.
		self parseConstantDo: [:v | ^v].
		char isLetter ifTrue: [^self parseObject].
		char = ${ ifTrue: [^self parseMap].
		char = $[ ifTrue: [^self parseList].
		(char = $' or: [char = $"]) ifTrue: [^self parseString].
		char = $# ifTrue: [^self parseSymbol].
		char = $@ ifTrue: [^self parseReference].
		(char = $- or: [char isDigit]) ifTrue: [^self parseNumber]].
	self error: 'invalid input'
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseString
	^self parseStringInternal
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseStringInternal
	| result delimiter |
	delimiter := stream next.
	(delimiter = $' or: [delimiter = $"])
		ifFalse: [self error: ''' or " expected'].
	result := self stringStreamContents: [:strm | 
		[stream atEnd or: [stream peek = delimiter]]
			whileFalse: [strm nextPut: self parseCharacter]].
	self expectChar: delimiter.
	^result
! !

!STONReader methodsFor:  'parsing-internal' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseSymbol
	| string |
	self expectChar: $#.
	stream peek = $' ifTrue: [^self parseStringInternal asSymbol].
	string := self stringStreamContents: [:strm | 
		[stream atEnd not and: [self isSimpleSymbolChar: stream peek]]
			whileTrue: [strm nextPut: stream next]].
	string isEmpty ifFalse: [
		self consumeWhitespace.
		^string asSymbol].
	self error: 'unexpected input'
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseTrailingSurrogateHexEscape
	(stream next = $\ and: [stream next = $u])
		ifTrue: [^self parseCharacterHex4Value]
		ifFalse: [self error: 'trailing surrogate hex escape expected']
! !

!STONReader methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseValue
	| value |
	value := self parseSimpleValue.
	^(self matchChar: $:)
		ifTrue: [STON associationClass key: value value: self parseValue]
		ifFalse: [value]
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
process: data
	| type |
	type := data first.
	type == #ref ifTrue: [^self processReference: data].
	type == #assoc ifTrue: [^self processAssociation: data].
	type == #elem ifTrue: [^self processElement: data].
	self error: 'unknown type'
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
processAssociation: data
	| k v assoc |
	k := data second isStonReference
		ifTrue: [objects at: data second index]
		ifFalse: [data second].
	v := data last isStonReference
		ifTrue: [objects at: data last index]
		ifFalse: [data last].
	assoc := data third associationAt: data second.
	assoc key == k ifFalse: [data third removeKey: data second].
	data third at: k put: v
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
processElement: data
	| o |
	o := objects at: data second index.
	data size = 4
		ifTrue: [data third at: data fourth put: o]
		ifFalse: [data third remove: data second; add: o]
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
processReference: data
	| o |
	o := objects at: data second.
	data third instVarAt: data fourth put: o
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
processUnresolved
	[references size > 0] whileTrue: [
		self process: references removeFirst.
		unresolved := unresolved - 1]
! !

!STONReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset
	unresolved := 0.
	objects removeAll.
	references removeAll
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolveReference: reference
	unresolved := unresolved - 1.
	^self resolveReferenceIndex: reference index
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolveReferenceIndex: anInteger
	^objects at: anInteger
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
setReference: aSTONReference to: anObject
	objects at: aSTONReference index put: anObject
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
storeReference: anObject
	| index |
	index := objects size + 1.
	objects at: index put: anObject.
	^index
! !

!STONReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
stringStreamContents: aBlock
	stringStream isNil
		ifTrue: [stringStream := '' writeStream]
		ifFalse: [stringStream reset].
	aBlock value: stringStream.
	^stringStream contents
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STONReader class' category: #STON!
STONReader class
	instanceVariableNames: ''!

!STONReader class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aStream
	^self new on: aStream
! !


STONReader initialize!

