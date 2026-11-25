'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TOMLParser category: #TOML!
Object subclass: #TOMLParser
	instanceVariableNames: 'stream root current'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TOML'!
!TOMLParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!TOMLParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
atTripleQuote: aCharacter
	| position |
	stream peek = aCharacter ifFalse: [^false].
	position := stream position.
	stream next.
	(stream peekFor: aCharacter) ifTrue: [
		(stream peekFor: aCharacter) ifTrue: [^true]].
	stream position: position.
	^false
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
error: aString
	^Error signal: 'TOML parse error at position ',
		stream position asString, ': ', aString
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
expect: aString
	aString do: [:each |
		(stream peekFor: each) ifFalse: [
			self error: 'Expected "', aString, '"']]
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
expectChar: aCharacter
	| found |
	(stream peekFor: aCharacter) ifTrue: [^self].
	found := stream atEnd
		ifTrue: ['end of input']
		ifFalse: [stream peek asString].
	self error: 'Expected ', aCharacter asString, ' but got ', found
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
hexValue: aCharacter
	| code |
	code := aCharacter asInteger.
	(code between: 48 and: 57) ifTrue: [^code - 48].
	(code between: 65 and: 70) ifTrue: [^code - 55].
	(code between: 97 and: 102) ifTrue: [^code - 87].
	self error: 'Invalid hex digit'
! !

!TOMLParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isBareKeyChar: aCharacter
	^aCharacter isAlphanumeric or: [aCharacter = $- or: [aCharacter = $_]]
! !

!TOMLParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isBinaryChar: aCharacter
	^aCharacter = $0 or: [aCharacter = $1 or: [aCharacter = $_]]
! !

!TOMLParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isHexChar: aCharacter
	^aCharacter isDigit or: [
		(aCharacter between: $a and: $f) or: [
	(aCharacter between: $A and: $F) or: [aCharacter = $_]]]
! !

!TOMLParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isNewline: aCharacter
	^aCharacter = Character cr or: [aCharacter = Character lf]
! !

!TOMLParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isOctalChar: aCharacter
	^(aCharacter between: $0 and: $7) or: [aCharacter = $_]
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
matchChar: aCharacter
	^stream peekFor: aCharacter
! !

!TOMLParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
on: aReadStream
	stream := aReadStream
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parse
	root := OrderedDictionary new.
	current := root.
	[stream atEnd] whileFalse: [self parseLine].
	^root
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseArray
	| elements |
	self expectChar: $[.
	elements := OrderedCollection new.
	self skipWhitespaceAndNewlines.
	(self matchChar: $]) ifTrue: [^elements asArray].
	[
		self skipWhitespaceAndNewlines.
		elements add: self parseValue.
		self skipWhitespaceAndNewlines.
		self matchChar: $,] whileTrue: [
			self skipWhitespaceAndNewlines.
			(stream peek = $]) ifTrue: [
				self expectChar: $].
				^elements asArray]].
	self skipWhitespaceAndNewlines.
	self expectChar: $].
	^elements asArray
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseArrayTable
	| key table array |
	self skipWhitespace.
	key := self parseDottedKey.
	self
		skipWhitespace;
		expectChar: $];
		expectChar: $];
		skipToNewline.
	table := self resolveTable: key allButLast create: true.
	array := table at: key last ifAbsent: [nil].
	array ifNil: [
		array := OrderedCollection new.
		table at: key last put: array].
	current := OrderedDictionary new.
	array add: current
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseBareKey
	| start |
	start := stream position.
	[stream atEnd not and: [self isBareKeyChar: stream peek]]
		whileTrue: [stream next].
	stream position = start ifTrue: [self error: 'Empty bare key'].
	^stream collection copyFrom: start + 1 to: stream position
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseBasicString
	self expectChar: $".
	^self parseBasicStringBody
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseBasicStringBody
	| result |
	result := String streamContents: [:s |
		[stream atEnd or: [stream peek = $"]]
			whileFalse: [s nextPut: self parseCharacter]].
	self expectChar: $".
	^result
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseBinaryInteger: aBoolean
	| value count |
	value := 0.
	count := 0.
	[stream atEnd not and: [self isBinaryChar: stream peek]]
		whileTrue: [
	| digit |
			digit := stream next.
			digit = $_ ifFalse: [
				value := value * 2 + digit digitValue.
				count := count + 1]].
	count = 0 ifTrue: [self error: 'Expected binary digit'].
	aBoolean ifTrue: [^value negated].
	^value
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseCharacter
	| char |
	char := stream next.
	char = $\ ifTrue: [^self parseEscape].
	^char
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseDecimalNumber: aBoolean
	| integer |
	integer := self parseDigits.
	(stream atEnd not and: [stream peek = $.]) ifTrue: [
		stream next.
		^self parseFloat: integer negated: aBoolean].
	(stream atEnd not and: [stream peek = $e or: [stream peek = $E]]) ifTrue: [
		stream next.
		^self parseExponent: integer asFloat negated: aBoolean].
	aBoolean ifTrue: [^integer negated].
	^integer
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseDigits
	| value count |
	value := 0.
	count := 0.
	[stream atEnd not and: [stream peek isDigit or: [stream peek = $_]]]
		whileTrue: [
	| digit |
			digit := stream next.
			digit = $_ ifFalse: [
				value := value * 10 + digit digitValue.
				count := count + 1]].
	count = 0 ifTrue: [self error: 'Expected digit'].
	^value
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseDottedKey
	| parts |
	parts := OrderedCollection new.
	parts add: self parseKey.
	[self skipWhitespace. stream peekFor: $.] whileTrue: [
		self skipWhitespace.
		parts add: self parseKey].
	^parts asArray
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseEscape
	| char |
	char := stream next.
	char = $b ifTrue: [^Character backspace].
	char = $t ifTrue: [^Character tab].
	char = $n ifTrue: [^Character lf].
	char = $f ifTrue: [^Character newPage].
	char = $r ifTrue: [^Character cr].
	char = $" ifTrue: [^$"].
	char = $\ ifTrue: [^$\].
	char = $u ifTrue: [^self parseUnicode: 4].
	char = $U ifTrue: [^self parseUnicode: 8].
	self error: 'Invalid escape: \', char asString
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseExponent: aNumber negated: aBoolean
	| negative exponent result |
	negative := stream peekFor: $-.
	negative ifFalse: [stream peekFor: $+].
	exponent := self parseDigits.
	negative ifTrue: [exponent := exponent negated].
	result := aNumber * (10 raisedTo: exponent).
	aBoolean ifTrue: [^result negated].
	^result
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseFalse
	self expect: 'false'.
	^false
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseFloat: anInteger negated: aBoolean
	| fraction power result |
	fraction := 0.
	power := 1.0.
	[stream atEnd not and: [stream peek isDigit or: [stream peek = $_]]]
		whileTrue: [
	| digit |
			digit := stream next.
			digit = $_ ifFalse: [
				fraction := fraction * 10 + digit digitValue.
				power := power * 10.0]].
	result := anInteger + (fraction / power).
	(stream atEnd not and: [stream peek = $e or: [stream peek = $E]]) ifTrue: [
		stream next.
		^self parseExponent: result negated: aBoolean].
	aBoolean ifTrue: [^result negated].
	^result
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseHexDigit
	| char code |
	stream atEnd ifTrue: [self error: 'Expected hex digit'].
	char := stream next.
	code := char asInteger.
	(code between: 48 and: 57) ifTrue: [^code - 48].
	(code between: 65 and: 70) ifTrue: [^code - 55].
	(code between: 97 and: 102) ifTrue: [^code - 87].
	self error: 'Invalid hex digit: ', char asString
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseHexInteger: aBoolean
	| value count |
	value := 0.
	count := 0.
	[stream atEnd not and: [self isHexChar: stream peek]]
		whileTrue: [ | digit |
			digit := stream next.
			digit = $_ ifFalse: [
				value := (value bitShift: 4) + (self hexValue: digit).
				count := count + 1]].
	count = 0 ifTrue: [self error: 'Expected hex digit'].
	aBoolean ifTrue: [^value negated].
	^value
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseInlineTable
	| table |
	self expectChar: ${.
	table := OrderedDictionary new.
	self skipWhitespace.
	(self matchChar: $}) ifTrue: [^table].
	[
		self skipWhitespace.
		self parseKeyValueInto: table.
		self skipWhitespace.
		self matchChar: $,] whileTrue.
	self skipWhitespace.
	self expectChar: $}.
	^table
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseKey
	| char |
	stream atEnd ifTrue: [self error: 'Expected key'].
	char := stream peek.
	char = $" ifTrue: [^self parseBasicString].
	char = $' ifTrue: [^self parseLiteralString].
	^self parseBareKey
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseKeyValue
	| key value target last |
	key := self parseDottedKey.
	self
		skipWhitespace;
		expectChar: $=;
		skipWhitespace.
	value := self parseValue.
	self skipToNewline.
	target := self resolveIn: current path: key allButLast create: true.
	last := key last.
	(target includesKey: last)
		ifTrue: [self error: 'Duplicate key: ', last].
	target at: last put: value
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseKeyValueInto: aDictionary
	| key value target |
	key := self parseDottedKey.
	self
		skipWhitespace;
		expectChar: $=;
		skipWhitespace.
	value := self parseValue.
	target := self resolveIn: aDictionary path: key allButLast create: true.
	target at: key last put: value
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseLine
	| char |
	self skipWhitespace.
	stream atEnd ifTrue: [^self].
	char := stream peek.
	char = $# ifTrue: [^self skipComment].
	char = $[ ifTrue: [^self parseTableHeader].
	(char = Character cr or: [char = Character lf])
		ifTrue: [^self skipNewline].
	self parseKeyValue
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseLiteralString
	self expectChar: $'.
	^self parseLiteralStringBody
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseLiteralStringBody
	| result |
	result := String streamContents: [:s |
		[stream atEnd or: [stream peek = $']]
			whileFalse: [s nextPut: stream next]].
	self expectChar: $'.
	^result
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseLiteralStringValue
	stream next.
	(stream peekFor: $')
		ifTrue: [
			(stream peekFor: $')
				ifTrue: [^self parseMultilineLiteralString]
				ifFalse: [^'']]
		ifFalse: [^self parseLiteralStringBody]
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseMultilineBasicChar: aStream
	| char |
	char := stream next.
	char = $\ ifFalse: [^aStream nextPut: char].
	(self isNewline: stream peek)
		ifTrue: [self skipWhitespaceAndNewlines]
		ifFalse: [stream back. aStream nextPut: self parseCharacter]
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseMultilineBasicString
	self skipNewlineIfPresent.
	^String streamContents: [:s |
		[stream atEnd or: [self atTripleQuote: $"]]
			whileFalse: [self parseMultilineBasicChar: s]]
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseMultilineLiteralString
	self skipNewlineIfPresent.
	^String streamContents: [:s |
		[stream atEnd or: [self atTripleQuote: $']]
			whileFalse: [s nextPut: stream next]]
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseNumberValue
	| start negated sign |
	negated := false.
	sign := stream peek.
	(sign = $+ or: [sign = $-]) ifTrue: [
		negated := sign = $-.
		stream next].
	start := stream position.
	stream peek = $0 ifTrue: [
		^self parsePrefixedNumber: negated from: start].
	^self parseDecimalNumber: negated
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseOctalInteger: aBoolean
	| value count |
	value := 0.
	count := 0.
	[stream atEnd not and: [self isOctalChar: stream peek]]
		whileTrue: [
	| digit |
			digit := stream next.
			digit = $_ ifFalse: [
				value := value * 8 + digit digitValue.
				count := count + 1]].
	count = 0 ifTrue: [self error: 'Expected octal digit'].
	aBoolean ifTrue: [^value negated].
	^value
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parsePrefixedNumber: aBoolean from: anInteger
	| prefix |
	stream next.
	stream atEnd ifTrue: [^0].
	prefix := stream peek.
	prefix = $x ifTrue: [stream next. ^self parseHexInteger: aBoolean].
	prefix = $o ifTrue: [stream next. ^self parseOctalInteger: aBoolean].
	prefix = $b ifTrue: [stream next. ^self parseBinaryInteger: aBoolean].
	(prefix = $. or: [prefix = $e or: [prefix = $E]])
		ifTrue: [stream position: anInteger. ^self parseDecimalNumber: aBoolean].
	^0
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseSpecialFloat
	| position |
	position := stream position.
	(self tryMatch: 'inf') ifTrue: [^Float infinity].
	(self tryMatch: 'nan') ifTrue: [^Float nan].
	stream position: position.
	self error: 'Unexpected character'
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseStringValue
	stream next.
	(stream peekFor: $")
		ifTrue: [
			(stream peekFor: $")
				ifTrue: [^self parseMultilineBasicString]
				ifFalse: [^'']]
		ifFalse: [^self parseBasicStringBody]
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseTable
	| key |
	self skipWhitespace.
	key := self parseDottedKey.
	self
		skipWhitespace;
		expectChar: $];
		skipToNewline.
	current := self resolveTable: key create: true
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseTableHeader
	stream next.
	(stream peekFor: $[)
		ifTrue: [self parseArrayTable]
		ifFalse: [self parseTable]
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseTrue
	self expect: 'true'.
	^true
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseUnicode: anInteger
	| value |
	value := 0.
	anInteger timesRepeat: [
		value := (value bitShift: 4) + self parseHexDigit].
	^Character codePoint: value
! !

!TOMLParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseValue
	| char |
	stream atEnd ifTrue: [self error: 'Expected value'].
	char := stream peek.
	char = $" ifTrue: [^self parseStringValue].
	char = $' ifTrue: [^self parseLiteralStringValue].
	char = $t ifTrue: [^self parseTrue].
	char = $f ifTrue: [^self parseFalse].
	char = $[ ifTrue: [^self parseArray].
	char = ${ ifTrue: [^self parseInlineTable].
	(char = $- or: [char = $+ or: [char isDigit]])
		ifTrue: [^self parseNumberValue].
	char = $i ifTrue: [^self parseSpecialFloat].
	char = $n ifTrue: [^self parseSpecialFloat].
	self error: 'Unexpected character: ', char asString
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
resolveIn: aDictionary path: anArray create: aBoolean
	| table |
	table := aDictionary.
	anArray do: [:key |
		| next |
		next := table at: key ifAbsent: [nil].
		next ifNil: [
			aBoolean ifFalse: [^nil].
			next := OrderedDictionary new.
			table at: key put: next].
		(next isKindOf: OrderedCollection)
			ifTrue: [table := next last]
			ifFalse: [table := next]].
	^table
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
resolveTable: anArray create: aBoolean
			^self resolveIn: root path: anArray create: aBoolean
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipComment
	[stream atEnd not and: [(self isNewline: stream peek) not]]
		whileTrue: [stream next]
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipNewline
	(stream peekFor: Character cr) ifTrue: [stream peekFor: Character lf].
	stream peekFor: Character lf
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipNewlineIfPresent
	(stream atEnd not and: [self isNewline: stream peek])
		ifTrue: [self skipNewline]
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipToNewline
	self skipWhitespace.
	stream atEnd ifTrue: [^self].
	stream peek = $# ifTrue: [self skipComment].
	stream atEnd ifTrue: [^self].
	(self isNewline: stream peek)
		ifTrue: [self skipNewline]
		ifFalse: [self error: 'Expected newline, got: ', stream peek asString]
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipWhitespace
	[stream atEnd not and: [
		| char |
		char := stream peek.
		char = Character space or: [char = Character tab]]]
		whileTrue: [stream next]
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipWhitespaceAndNewlines
	[stream atEnd not and: [
		| char |
		char := stream peek.
		char = Character space or: [
			char = Character tab or: [
				char = Character cr or: [
					char = Character lf or: [char = $#]]]]]]
		whileTrue: [
			stream peek = $#
				ifTrue: [self skipComment]
				ifFalse: [stream next]]
! !

!TOMLParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
tryMatch: aString
	| position |
	position := stream position.
	aString do: [:each |
		(stream peekFor: each) ifFalse: [
			stream position: position.
			^false]].
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TOMLParser class' category: #TOML!
TOMLParser class
	instanceVariableNames: ''!

!TOMLParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
on: aReadStream
	^self new on: aReadStream
! !

!TOMLParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
parse: aString
	^(self on: aString readStream) parse
! !


