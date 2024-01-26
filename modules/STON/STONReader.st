"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STONReader, 
	#superclass : #Object, 
	#instVars : [
		'stream', 
		'objects', 
		'classes', 
		'unresolved', 
		'stringStream', 
		'references'
	], 
	#category : #STON
}

{#category : #'instance creation'}
STONReader class >> new [
	^super new initialize
]

{#category : #'instance creation'}
STONReader class >> on: aStream [
	^self new on: aStream
]

{#category : #'adding / removing'}
STONReader >> addElement: v of: collection [
	self addElement: v of: collection at: nil
]

{#category : #'adding / removing'}
STONReader >> addElement: element of: collection at: index [
	| data |
	references isNil ifTrue: [references := OrderedCollection new].
	data := index isNil
		ifTrue: [{#elem. element. collection}]
		ifFalse: [{#elem. element. collection. index}].
	references add: data
]

{#category : #'adding / removing'}
STONReader >> addReference: aSTONReference of: anObject at: anInteger [
	references isNil ifTrue: [references := OrderedCollection new].
	references add: {#ref. aSTONReference index. anObject. anInteger}
]

{#category : #'adding / removing'}
STONReader >> addReferenceKey: k value: v of: dictionary [
	references isNil ifTrue: [references := OrderedCollection new].
	references add: {#assoc. k. dictionary. v}
]

{#category : #testing}
STONReader >> atEnd [
	^stream atEnd
]

{#category : #open/close}
STONReader >> close [
	stream isNil ifTrue: [^self].
	stream close.
	stream := nil
]

{#category : #private}
STONReader >> consumeWhitespace [
	stream skipSeparators
]

{#category : #'error handling'}
STONReader >> error: aString [
	| position |
	position := [stream position] on: MessageNotUnderstood do: [].
	^STONReaderError signal: aString streamPosition: position
]

{#category : #private}
STONReader >> expectChar: aCharacter [
	(self matchChar: aCharacter)
		ifFalse: [self error: aCharacter asString , ' expected']
]

{#category : #initialization}
STONReader >> initialize [
	super initialize.
	objects := IdentityDictionary new.
	classes := IdentityDictionary new.
	unresolved := 0
]

{#category : #private}
STONReader >> isClassChar: aCharacter [
	^'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
		includes: aCharacter
]

{#category : #private}
STONReader >> isSimpleSymbolChar: aCharacter [
	^aCharacter isLetter or: ['0123456789-_./' includes: aCharacter]
]

{#category : #private}
STONReader >> lookupClass: aString [
	(Smalltalk classNamed: aString) ifNotNil: [:class | ^class].
	^classes at: aString ifAbsentPut: [
		Object allSubclasses
			detect: [:class | class isMetaclass not and: [class stonName = aString]]
			ifNone: [Error signal: aString , ' not found']]
]

{#category : #private}
STONReader >> match: aString do: aBlock [
	(aString conform: [:ch | stream peekFor: ch]) ifTrue: [
		self consumeWhitespace.
		aBlock value]
]

{#category : #private}
STONReader >> matchChar: aCharacter [
	^(stream peekFor: aCharacter) ifTrue: [self consumeWhitespace]; yourself
]

{#category : #private}
STONReader >> newReference [
	| index reference |
	index := objects size + 1.
	reference := STONReference index: index.
	^objects at: index put: reference
]

{#category : #public}
STONReader >> next [
	| object |
	self consumeWhitespace.
	object := self parseValue.
	unresolved > 0 ifTrue: [self processUnresolved].
	unresolved = 0 ifFalse: [self error: 'Inconsistent reference resolution'].
	objects do: [:o | o stonPostReferenceResolution].
	^object
]

{#category : #accessing}
STONReader >> on: aStream [
	stream := aStream
]

{#category : #parsing-internal}
STONReader >> parseCharacter [
	| char |
	char := stream next.
	^char = $\ ifTrue: [self parseEscapedCharacter] ifFalse: [char]
]

{#category : #private}
STONReader >> parseCharacterHex [
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
]

{#category : #private}
STONReader >> parseCharacterHex4Value [
	| value |
	value := self parseCharacterHexDigit.
	3 timesRepeat: [value := (value bitShift: 4) + self parseCharacterHexDigit].
	^value
]

{#category : #parsing-internal}
STONReader >> parseCharacterHexDigit [
	| digit |
	stream atEnd ifFalse: [
		digit := stream next asInteger.
		(digit between: 48 and: 57) ifTrue: [^digit - 48].
		(digit between: 65 and: 70) ifTrue: [^digit - 55].
		(digit between: 97 and: 102) ifTrue: [^digit - 87]].
	self error: 'hex-digit expected'
]

{#category : #parsing-internal}
STONReader >> parseClass [
	| class |
	class := self stringStreamContents: [:strm | 
		[stream atEnd not and: [self isClassChar: stream peek]]
			whileTrue: [strm nextPut: stream next]].
	self consumeWhitespace.
	^self lookupClass: class asSymbol
]

{#category : #parsing-internal}
STONReader >> parseConstantDo: aBlock [
	| keys values |
	keys := #('true' 'false' 'nil' 'null').
	values := #(true false nil nil).
	1 to: keys size do: [:i | | key |
		key := keys at: i.
		(stream peek = key first and: [(stream peek: key size) = key]) ifTrue: [
			stream skip: key size.
			self consumeWhitespace.
			^aBlock value: (values at: i)]]
]

{#category : #parsing-internal}
STONReader >> parseEscapedCharacter [
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
]

{#category : #parsing}
STONReader >> parseList [
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
]

{#category : #parsing}
STONReader >> parseListDo: aBlock [
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
]

{#category : #parsing}
STONReader >> parseListSingleton [
	| value |
	value := nil.
	self parseListDo: [:element :i | i = 1 ifTrue: [value := element]].
	^value
]

{#category : #parsing}
STONReader >> parseMap [
	| map |
	map := STON mapClass new.
	self
		storeReference: map;
		parseMapDo: [:key :value | 
			map at: key put: value.
			(key isStonReference or: [value isStonReference])
				ifTrue: [self addReferenceKey: key value: value of: map]].
	^map
]

{#category : #parsing}
STONReader >> parseMapDo: aBlock [
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
]

{#category : #parsing}
STONReader >> parseNamedInstVarsFor: anObject [
	| i |
	i := 1.
	self parseMapDo: [:ivar :value | 
		anObject instVarNamed: ivar put: value.
		value isStonReference
			ifTrue: [self addReference: value of: anObject at: i].
		i := i + 1]
]

{#category : #parsing-internal}
STONReader >> parseNumber [
	| negated number |
	negated := stream peekFor: $-.
	number := self parseNumberInteger.
	(stream peekFor: $.) ifTrue: [number := number + self parseNumberFraction].
	((stream peekFor: $e) or: [stream peekFor: $E])
		ifTrue: [number := number * self parseNumberExponent].
	negated ifTrue: [number := number negated].
	self consumeWhitespace.
	^number
]

{#category : #parsing-internal}
STONReader >> parseNumberExponent [
	| number negated |
	number := 0.
	negated := stream peekFor: $-.
	negated ifFalse: [stream peekFor: $+].
	[stream atEnd not and: [stream peek isDigit]]
		whileTrue: [number := 10 * number + stream next digitValue].
	negated ifTrue: [number := number negated].
	^10 raisedTo: number
]

{#category : #parsing-internal}
STONReader >> parseNumberFraction [
	| number power |
	number := 0.
	power := 1.0.
	[stream atEnd not and: [stream peek isDigit]] whileTrue: [
		number := 10 * number + stream next digitValue.
		power := power * 10.0].
	^number / power
]

{#category : #parsing-internal}
STONReader >> parseNumberInteger [
	| number |
	number := 0.
	[stream atEnd not and: [stream peek isDigit]]
		whileTrue: [number := 10 * number + stream next digitValue].
	^number
]

{#category : #parsing}
STONReader >> parseObject [
	| object |
	[| reference class |
		reference := self newReference.
		class := self parseClass.
		object := class fromSton: self.
		self setReference: reference to: object]
		on: Error
		do: [self error: 'Cannot resolve class named ' , object printString].
	^object
]

{#category : #parsing-internal}
STONReader >> parseReference [
	| index |
	self expectChar: $@.
	index := self parseNumberInteger.
	self consumeWhitespace.
	unresolved := unresolved + 1.
	^STONReference index: index
]

{#category : #parsing}
STONReader >> parseSimpleValue [
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
]

{#category : #parsing-internal}
STONReader >> parseString [
	^self parseStringInternal
]

{#category : #parsing-internal}
STONReader >> parseStringInternal [
	| result delimiter |
	delimiter := stream next.
	(delimiter = $' or: [delimiter = $"])
		ifFalse: [self error: ''' or " expected'].
	result := self stringStreamContents: [:strm | 
		[stream atEnd or: [stream peek = delimiter]]
			whileFalse: [strm nextPut: self parseCharacter]].
	self expectChar: delimiter.
	^result
]

{#category : #parsing-internal}
STONReader >> parseSymbol [
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
]

{#category : #private}
STONReader >> parseTrailingSurrogateHexEscape [
	(stream next = $\ and: [stream next = $u])
		ifTrue: [^self parseCharacterHex4Value]
		ifFalse: [self error: 'trailing surrogate hex escape expected']
]

{#category : #parsing}
STONReader >> parseValue [
	| value |
	value := self parseSimpleValue.
	^(self matchChar: $:)
		ifTrue: [STON associationClass key: value value: self parseValue]
		ifFalse: [value]
]

{#category : #private}
STONReader >> process: data [
	| type |
	type := data first.
	type == #ref ifTrue: [^self processReference: data].
	type == #assoc ifTrue: [^self processAssociation: data].
	type == #elem ifTrue: [^self processElement: data].
	self error: 'unknown type'
]

{#category : #private}
STONReader >> processAssociation: data [
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
]

{#category : #private}
STONReader >> processElement: data [
	| o |
	o := objects at: data second index.
	data size = 4
		ifTrue: [data third at: data fourth put: o]
		ifFalse: [data third remove: data second; add: o]
]

{#category : #private}
STONReader >> processReference: data [
	| o |
	o := objects at: data second.
	data third instVarAt: data fourth put: o
]

{#category : #private}
STONReader >> processUnresolved [
	[references size > 0] whileTrue: [
		self process: references removeFirst.
		unresolved := unresolved - 1]
]

{#category : #accessing}
STONReader >> reset [
	unresolved := 0.
	objects removeAll.
	references removeAll
]

{#category : #private}
STONReader >> resolveReference: reference [
	unresolved := unresolved - 1.
	^self resolveReferenceIndex: reference index
]

{#category : #private}
STONReader >> resolveReferenceIndex: anInteger [
	^objects at: anInteger
]

{#category : #private}
STONReader >> setReference: aSTONReference to: anObject [
	objects at: aSTONReference index put: anObject
]

{#category : #private}
STONReader >> storeReference: anObject [
	| index |
	index := objects size + 1.
	objects at: index put: anObject.
	^index
]

{#category : #private}
STONReader >> stringStreamContents: aBlock [
	stringStream isNil
		ifTrue: [stringStream := '' writeStream]
		ifFalse: [stringStream reset].
	aBlock value: stringStream.
	^stringStream contents
]

