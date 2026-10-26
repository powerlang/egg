'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonParser category: #JSON!
Object subclass: #JsonParser
	instanceVariableNames: 'stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonParser commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
consumeWhitespace
	[stream atEnd not and: [stream peek isBlank]] whileTrue: [stream next]
! !

!JsonParser methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:41'!
error: aString
	^JsonError signal: aString at: stream position context: stream context
! !

!JsonParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
expectChar: character
	(self matchChar: character) ifFalse: [
		self
			error: 'the character ' , character asString storeString
				, ' rather than '
				, stream peek asString storeString
				, ' was expected']
! !

!JsonParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
match: string do: block
	(string conform: [:ch | stream peekFor: ch]) ifTrue: [
		self consumeWhitespace.
		block value]
! !

!JsonParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
matchChar: character
	^(stream peekFor: character) ifTrue: [self consumeWhitespace]; yourself
! !

!JsonParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
next
	^self parseValue
! !

!JsonParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
on: aReadStream
	stream := aReadStream
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseCharacter
	| char |
	char := stream next.
	char = $\ ifFalse: [^char].
	char := stream next.
	('/"\' includes: char) ifTrue: [^char].
	('bfnrt' includes: char) ifTrue: [^self unescapeChar: char].
	char = $u ifTrue: [^self parseCharacterHex].
	self
		error: 'the invalid escape character \' , char asString storeString
			, ' occurred'
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseCharacterHex
	| value codePoint |
	value := self parseCharacterHex4Value.
	(value < 16rD800 or: [value > 16rDBFF])
		ifTrue: [codePoint := value]
		ifFalse: [| leadSurrogate trailSurrogate |
			"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"
			"See https://tools.ietf.org/html/rfc7159#section-7"
			leadSurrogate := value.
			trailSurrogate := self parseTrailingSurrogateHexEscape.
			codePoint := leadSurrogate - 16rD800 * 16r400 + (trailSurrogate - 16rDC00).
			codePoint := 16r10000 + codePoint].
	^Character codePoint: codePoint
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseCharacterHex4Value
	| value |
	value := self parseCharacterHexDigit.
	3 timesRepeat: [value := (value bitShift: 4) + self parseCharacterHexDigit].
	^value
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseCharacterHexDigit
	| digit char |
	stream atEnd ifFalse: [
		char := stream next.
		digit := char asInteger.
		(digit between: "$0" 48 and: "$9" 57) ifTrue: [^digit - 48].
		(digit between: "$A" 65 and: "$F" 70) ifTrue: [^digit - 55].
		(digit between: "$a" 97 and: "$f" 102) ifTrue: [^digit - 87]].
	self
		error: 'an hex-digit rather than ' , char asString storeString
			, ' was expected'
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseConstantDo: block
	stream peek = $t ifTrue: [^self match: 'true' do: [block value: true]].
	stream peek = $f ifTrue: [^self match: 'false' do: [block value: false]].
	stream peek = $n ifTrue: [^self match: 'null' do: [block value: nil]]
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseList
	^Array
		streamContents: [:strm | self
			parseListElementsDo: [:each | strm nextPut: each]]
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseListDo: block
	self expectChar: $[.
	(self matchChar: $]) ifTrue: [^self].
	[stream atEnd] whileFalse: [
		block value.
		(self matchChar: $]) ifTrue: [^self].
		self expectChar: $,].
	self error: 'an end of list was expected'
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseListElementsDo: block
	self parseListDo: [block value: self parseValue]
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseMap
	| map |
	map := JsonObject new.
	self parseMapKeysAndValuesDo: [:key :value | map at: key put: value].
	^map
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseMapDo: block
	self expectChar: ${.
	(self matchChar: $}) ifTrue: [^self].
	[stream atEnd] whileFalse: [
		block value.
		(self matchChar: $}) ifTrue: [^self].
		self expectChar: $,].
	self error: 'an end of map was expected'
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseMapKeysAndValuesDo: block
	self parseMapKeysDo: [:key | block value: key value: self parseValue]
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseMapKeysDo: block
	self parseMapDo: [| key |
		key := self parsePropertyName.
		self expectChar: $:.
		block value: key]
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
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

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseNumberExponent
	| number negated |
	number := 0.
	(negated := stream peekFor: $-) ifFalse: [stream peekFor: $+].
	[stream atEnd not and: [stream peek isDigit]]
		whileTrue: [number := 10 * number + stream next digitValue].
	negated ifTrue: [number := number negated].
	^10 raisedTo: number
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseNumberFraction
	| number power |
	number := 0.
	power := 1.0.
	[stream atEnd not and: [stream peek isDigit]] whileTrue: [
		number := 10 * number + stream next digitValue.
		power := power * 10.0].
	^number / power
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseNumberInteger
	| number |
	number := nil.
	[stream atEnd not and: [stream peek isDigit]]
		whileTrue: [number := 10 * (number ifNil: [0]) + stream next digitValue].
	number ifNil: [self error: 'an integer digit was expected'].
	^number
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parsePropertyName
	| name |
	name := self parseValue.
	name isString ifTrue: [^name].
	self
		error: 'a property name must be a string, not '
			, name asString withArticle
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseString
	| result |
	self expectChar: $".
	result := String streamContents: [:strm | 
		[stream atEnd or: [stream peek = $"]]
			whileFalse: [strm nextPutChar: self parseCharacter]].
	self expectChar: $".
	^result
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseTrailingSurrogateHexEscape
	(stream next = $\ and: [stream next = $u])
		ifTrue: [^self parseCharacterHex4Value].
	self error: 'a trailing surrogate hex escape was expected'
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parseValue
	| char |
	stream atEnd ifTrue: [^self error: 'End of stream'] ifFalse: [
		char := stream peek.
		char = ${ ifTrue: [^self parseMap].
		char = $[ ifTrue: [^self parseList].
		char = $" ifTrue: [^self parseString].
		(char = $- or: [char isDigit]) ifTrue: [^self parseNumber].
		self parseConstantDo: [:value | ^value]].
	^self error: 'the character ' , char name , ' is invalid'
! !

!JsonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
unescapeChar: char
	char = $b ifTrue: [^Character backspace].
	char = $f ifTrue: [^Character newPage].
	char = $n ifTrue: [^Character lf].
	char = $r ifTrue: [^Character cr].
	char = $t ifTrue: [^Character tab].
	self
		error: 'the unknown escape character ' , char asString storeString
			, ' occured'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonParser class' category: #JSON!
JsonParser class
	instanceVariableNames: ''!

!JsonParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
on: aReadStream
	^self new on: aReadStream; yourself
! !

!JsonParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
parse: aString
	| parser string |
	string := aString isByteArray
		ifTrue: [UTF8 decode: aString]
		ifFalse: [aString].
	parser := self on: string readStream.
	^parser next
! !

!JsonParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
parse: aString for: aForeignNode
	^self parse: aString trimBlanks
! !


