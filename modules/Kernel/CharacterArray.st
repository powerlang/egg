"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CharacterArray,
	#superclass : #ArrayedCollection,
	#category : #Kernel
}

{ #category : #'instance creation' }
CharacterArray class >> fromSubstrings: substrings separatedBy: separatorChar [
	| stream |
	stream := self new writeStream.
	substrings
		do: [:string | stream nextPutAll: string asString]
		separatedBy: [stream nextPut: separatorChar].
	^stream contents
]

{ #category : #'initialization' }
CharacterArray class >> initializePools [
	self addNamespace: Character namedCharacters
]

{ #category : #'named characters' }
CharacterArray class >> lf [
	^self with: Lf
]

{ #category : #operations }
CharacterArray >> / aString [
	| string tail |
	string := (aString notEmpty and: [aString first = $/])
		ifTrue: [aString allButFirst]
		ifFalse: [aString].
	self isEmpty ifTrue: [^string].
	tail := string isEmpty ifTrue: [''] ifFalse: ['/' , string].
	^self last = $/ ifTrue: [self allButLast , tail] ifFalse: [self , tail]
]

{ #category : #operations }
CharacterArray >> \ aString [
	| filename |
	filename := self asFilename \ aString.
	^filename asString
]

{ #category : #comparing }
CharacterArray >> < aString [
	^(aString <= self) not
]

{ #category : #comparing }
CharacterArray >> << aString [
	| min |
	min := self size min: aString size.
	1 to: min do: [:i | | a b |
		a := (self at: i) asInteger.
		b := (aString at: i) asInteger.
		a < b ifTrue: [^true].
		a > b ifTrue: [^false]].
	^self size <= aString size
]

{ #category : #comparing }
CharacterArray >> <= aString [
	| iterations |
	self isUnicode == aString isUnicode ifFalse: [
		^(self isSymbol or: [aString isSymbol])
			ifTrue: [self asWideSymbol <= aString asWideSymbol]
			ifFalse: [self asWideString <= aString asWideString]].
	iterations := self size min: aString size.
	1 to: iterations do: [:i | | a b |
		a := (self at: i) asLowercase.
		b := (aString at: i) asLowercase.
		a < b ifTrue: [^true].
		a > b ifTrue: [^false]].
	^iterations = self size
]

{ #category : #comparing }
CharacterArray >> > aString [
	^(self <= aString) not
]

{ #category : #comparing }
CharacterArray >> >= aString [
	aString isString ifFalse: [^self error: 'argument is not a String'].
	^aString <= self
]

{ #category : #copying }
CharacterArray >> abbreviatedTo: n [
	"
	'A very long string to be curtailed' abbreviatedTo: 30
	"
	self size <= n ifTrue: [^self].
	^(self copyFrom: 1 to: (n - 1 max: 1)) , Character ellipsis asString
]

{ #category : #services }
CharacterArray >> article [
	| article first letter second |
	self isEmpty ifTrue: [^self].
	article := self first isVowel ifTrue: ['an'] ifFalse: ['a'].
	first := self first asLowercase.
	letter := self size = 1.
	second := letter ifFalse: [self second asLowercase].
	(first = $f and: [letter orNot: ['aeiloru' includes: second]])
		ifTrue: [^'an'].
	first = $u ifTrue: [
		(letter or: ['ck' includes: second]) ifTrue: [^'a'].
		second = $n
			ifTrue: [(self size = 2 or: [self third isVowel]) ifTrue: [^'a']]].
	(first = $e and: [second = $u]) ifTrue: [^'a'].
	^article
]

{ #category : #converting }
CharacterArray >> asFloat [
	^Float fromString: self
]

{ #category : #converting }
CharacterArray >> asInteger [
	^Integer fromString: self
]

{ #category : #converting }
CharacterArray >> asLowercase [
	| changed size lowercase |
	changed := false.
	size := self size.
	lowercase := self species new: size.
	1 to: size do: [:index | | c lc |
		c := self at: index.
		lc := c asLowercase.
		changed := c != lc | changed.
		lowercase at: index put: lc].
	^changed ifTrue: [lowercase] ifFalse: [self]
]

{ #category : #converting }
CharacterArray >> asNumber [
	^Number fromString: self
]

{ #category : #converting }
CharacterArray >> asString [
	^self
]

{ #category : #converting }
CharacterArray >> asUnicode [
	self ASSERT: false.
	^self asWideString
]

{ #category : #converting }
CharacterArray >> asUppercase [
	| changed answer size c uc |
	changed := false.
	size := self size.
	answer := self species new: size.
	1 to: size do: [:index | 
		c := self at: index.
		uc := c asUppercase.
		changed := c ~~ uc | changed.
		answer at: index put: uc].
	^changed ifTrue: [answer] ifFalse: [self]
]

{ #category : #converting }
CharacterArray >> asWideString [
	| n wide |
	n := self size.
	wide := WideString new: n.
	1 to: n do: [:i | | byte |
		byte := self byteAt: i.
		wide basicAt: i - 1 * 4 + 1 put: byte].
	^wide
]

{ #category : #accessing }
CharacterArray >> at: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
CharacterArray >> basicAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
CharacterArray >> basicAt: anInteger put: aCharacter [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	aCharacter isCharacter
		ifFalse: [^self
			error: self class name , ' can''t hold ' , aCharacter class name].
	aCharacter isByteCharacter
		ifFalse: [^self
			error: 'Strings cannot hold Unicode characters greater than 255'].
	^self _byteAt: anInteger put: aCharacter asInteger
]

{ #category : #accessing }
CharacterArray >> byteAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
]

{ #category : #accessing }
CharacterArray >> byteAt: position put: asciiValue [
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position <= self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
]

{ #category : #printing }
CharacterArray >> canBePrintedAsLiteral [
	^true
]

{ #category : #converting }
CharacterArray >> capitalized [
	| c |
	self isEmpty ifTrue: [^self].
	c := self first.
	c isUppercase ifTrue: [^self].
	^self copy at: 1 put: c asUppercase; yourself
]

{ #category : #private }
CharacterArray >> characterAtValid: index [
	| value |
	value := self _byteAt: index.
	^Character value: value
]

{ #category : #validation }
CharacterArray >> checkCharacter: aCharacter [
	aCharacter isCharacter
		ifFalse: [^self error: 'Improper store into indexable object']
]

{ #category : #private }
CharacterArray >> codeAt: i [
	^self byteAt: i
]

{ #category : #inquiries }
CharacterArray >> codePage [
	^KernelLibrary GetACP
]

{ #category : #services }
CharacterArray >> doubleQuoted [
	"
	'hello' doubleQuoted
	"
	self isEmpty ifTrue: [^self class new: 2 withAll: $"].
	^(self first = $" and: [self last = $"])
		ifTrue: [self]
		ifFalse: [$" , self copyWith: $"]
]

{ #category : #private }
CharacterArray >> eol [
	| n code |
	n := self size.
	n = 0 ifTrue: [^nil].
	code := self codeAt: n.
	code = 13 ifTrue: [^String cr].
	code = 10 ifTrue: [
		^n = 1
			ifTrue: [String lf]
			ifFalse: [(self codeAt: n - 1) = 13
				ifTrue: [String crlf]
				ifFalse: [String lf]]].
	1 to: n - 1 do: [:i | 
		code := self codeAt: i.
		code = 13
			ifTrue: [^(self codeAt: i + 1) = 10
				ifTrue: [String crlf]
				ifFalse: [String cr]].
		code = 10 ifTrue: [^String lf]].
	^nil
]

{ #category : #comparing }
CharacterArray >> equals: aString [
	| size |
	self class == aString class ifFalse: [^false].
	size := self basicSize.
	size = aString basicSize ifFalse: [^false].
	1
		to: size
		do: [:i | (aString _byteAt: i) = (self _byteAt: i) ifFalse: [^false]].
	^true
]

{ #category : #comparing }
CharacterArray >> equalsCaseInsensitive: aString [
	self size = aString size ifFalse: [^false].
	^self <= aString andNot: [self < aString]
]

{ #category : #services }
CharacterArray >> externalCopy [
	^UTF16 current externalCopyOf: self
]

{ #category : #filenames }
CharacterArray >> fileExtension [
	^self asFilename extension
]

{ #category : #filenames }
CharacterArray >> fileName [
	^self asFilename withoutExtension asString
]

{ #category : #services }
CharacterArray >> fileNameOnly [
	"
	'c:\dir\filename.ext' fileNameOnly
	"
	^self asFilename fileNameOnly
]

{ #category : #comparing }
CharacterArray >> hash [
	| hash |
	hash := self size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self byteAt: i)].
	^hash
]

{ #category : #inquiries }
CharacterArray >> includes: aCharacter [
	aCharacter isCharacter ifFalse: [^false].
	1 to: self size do: [:i | (self at: i) = aCharacter ifTrue: [^true]].
	^false
]

{ #category : #testing }
CharacterArray >> includesString: aString [
	^aString isEmpty or: [(self indexOfString: aString) > 0]
]

{ #category : #parsing }
CharacterArray >> indexOfLastChar: aCharacter [
	self size
		to: 1
		by: -1
		do: [:index | (self at: index) = aCharacter ifTrue: [^index]].
	^0
]

{ #category : #parsing }
CharacterArray >> indexOfLastString: aString [
	^self indexOfLastString: aString before: self size
]

{ #category : #parsing }
CharacterArray >> indexOfLastString: aString before: anInteger [
	^self indexOfLastString: aString from: 1 to: anInteger
]

{ #category : #parsing }
CharacterArray >> indexOfLastString: aString from: start to: stop [
	| n limit base i |
	n := aString size.
	limit := n + start.
	base := stop + 1.
	i := 1.
	[
		base < limit ifTrue: [^0].
		i <= n]
		whileTrue: [
			i := (self at: base - i) = (aString at: n - i + 1) ifTrue: [i + 1] ifFalse: [
				base := base - 1.
				1]].
	^i > 1 ifTrue: [base - n] ifFalse: [0]
]

{ #category : #parsing }
CharacterArray >> indexOfString: aString [
	^self indexOfString: aString startingAt: 1
]

{ #category : #parsing }
CharacterArray >> indexOfString: aString from: start to: stop [
	| n limit base i |
	n := aString size.
	limit := stop - n.
	base := start - 1.
	i := 1.
	[
		base > limit ifTrue: [^0].
		i <= n]
		whileTrue: [
			i := (self at: base + i) = (aString at: i) ifTrue: [i + 1] ifFalse: [
				base := base + 1.
				1]].
	^i > 1 ifTrue: [base + 1] ifFalse: [0]
]

{ #category : #parsing }
CharacterArray >> indexOfString: aString startingAt: anInteger [
	^self indexOfString: aString from: anInteger to: self size
]

{ #category : #parsing }
CharacterArray >> indexOfSubcollection: aString
from: start
to: stop
td1: anArray [
	^self indexOfString: aString from: start to: stop td1: anArray
]

{ #category : #testing }
CharacterArray >> isAnsiCompliant [
	1 to: self size do: [:i | | char |
		char := self at: i.
		char isAnsiCompliant ifFalse: [^false]].
	^true
]

{ #category : #testing }
CharacterArray >> isString [
	^true
]

{ #category : #testing }
CharacterArray >> isUnicode [
	^false
]

{ #category : #testing }
CharacterArray >> isWideString [
	^false
]

{ #category : #services }
CharacterArray >> lineAt: index [
	| read start line |
	read := self readStream.
	start := 1.
	line := 1.
	[read atEnd] whileFalse: [| end |
		end := start + read nextLine size.
		(index between: start and: end) ifTrue: [^line].
		line := line + 1.
		start := end]
]

{ #category : #services }
CharacterArray >> lines [
	| read |
	read := self readStream.
	^Array streamContents: [:write | 
		[
			write nextPut: read nextLine trimBlanks.
			read atEnd] whileFalse]
]

{ #category : #filenames }
CharacterArray >> pathName [
	"
	'c:\dir\name.ext' pathName
	"
	| slash index |
	self asFilename directoryExists ifTrue: [^self].
	slash := $\.
	index := self findLast: [:char | char == slash] ifAbsent: [^'.'].
	^self copyFrom: 1 to: index - 1
]

{ #category : #private }
CharacterArray >> primitiveSize [
	^self _size
]

{ #category : #converting }
CharacterArray >> reduced [
	^self
]

{ #category : #replacing }
CharacterArray >> replaceAll: aString with: anotherString [
	| string strm index fragment n |
	string := aString asString.
	string isEmpty ifTrue: [^self].
	index := self indexOfSubcollection: string startingAt: 1.
	index = 0 ifTrue: [^self].
	strm := self asString class new writeStream.
	fragment := self copyFrom: 1 to: index - 1.
	strm nextPutAll: fragment.
	n := string size.
	[index > 0] whileTrue: [| next limit |
		next := self indexOfString: string from: index + n to: self size.
		limit := next = 0 ifTrue: [self size + 1] ifFalse: [next].
		fragment := self copyFrom: index + n - 1 + 1 to: limit - 1.
		strm nextPutAll: anotherString; nextPutAll: fragment.
		index := next].
	^strm contents
]

{ #category : #replacing }
CharacterArray >> replaceAllChar: aCharacter with: aString [
	| index writer string n |
	self ASSERT: aCharacter isCharacter.
	index := self indexOf: aCharacter.
	index = 0 ifTrue: [^self].
	writer := self class new writeStream.
	string := self copyFrom: 1 to: index - 1.
	writer nextPutAll: string; nextPutAll: aString.
	n := self size.
	[index + 1 <= n] whileTrue: [| next |
		next := self
			indexOf: aCharacter
			between: index + 1
			and: n
			ifAbsent: [n + 1].
		string := self copyFrom: index + 1 to: next - 1.
		writer nextPutAll: string.
		next <= n ifTrue: [writer nextPutAll: aString].
		index := next].
	^writer contents
]

{ #category : #replacing }
CharacterArray >> replaceAllChar: aCharacter withChar: anotherCharacter [
	| copy |
	copy := self copy.
	1
		to: self size
		do: [:i | (self at: i) = aCharacter
			ifTrue: [copy at: i put: anotherCharacter]].
	^copy
]

{ #category : #marshalling }
CharacterArray >> shortAtOffset: offset [
	| integer |
	integer := self uShortAtOffset: offset.
	16r7FFF < integer ifTrue: [integer := integer - 16r10000].
	^integer
]

{ #category : #accessing }
CharacterArray >> size [
	^self _size
]

{ #category : #services }
CharacterArray >> split: aString [
	"
	' +- ' split: '2 +- 3 +- 4 +- 5'
	"
	| stream substrings |
	self size = 1 ifTrue: [^self first split: aString].
	stream := aString readStream.
	substrings := OrderedCollection new.
	[stream atEnd] whileFalse: [| s |
		s := stream upToAll: self.
		substrings add: s].
	^substrings
]

{ #category : #printing }
CharacterArray >> storeOn: aStream [
	self printOn: aStream
]

{ #category : #comparing }
CharacterArray >> stringHash [
	| hash |
	hash := self size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self byteAt: i)].
	^hash
]

{ #category : #parsing }
CharacterArray >> substrings [
	| substrings start size |
	substrings := OrderedCollection new.
	start := 1.
	size := self size.
	[start <= size] whileTrue: [| string stop |
		[start <= size and: [(self at: start) isBlank]]
			whileTrue: [start := start + 1].
		stop := start.
		[stop <= size and: [(self at: stop) isBlank not]]
			whileTrue: [stop := stop + 1].
		stop > start ifTrue: [
			string := self copyFrom: start to: stop - 1.
			substrings add: string].
		start := stop].
	^substrings asArray
]

{ #category : #parsing }
CharacterArray >> substringsSplitBy: aCharacter [
	| substrings start size |
	substrings := OrderedCollection new.
	start := 1.
	size := self size.
	[start <= size] whileTrue: [| stop string |
		stop := start.
		[stop <= size andNot: [(self at: stop) = aCharacter]]
			whileTrue: [stop := stop + 1].
		stop >= start ifTrue: [
			string := self copyFrom: start to: stop - 1.
			substrings add: string].
		start := stop + 1].
	^substrings asArray
]

{ #category : #parsing }
CharacterArray >> subwords [
	| i0 starting |
	i0 := 1.
	starting := false.
	^Array streamContents: [:strm | 
		1 to: self size do: [:i | | char |
			char := self at: i.
			(char isBlank or: [char isPunctuationMark])
				ifTrue: [
					starting ifFalse: [strm nextPut: (self copyFrom: i0 to: i - 1)].
					i0 := i + 1.
					starting := true]
				ifFalse: [
					(self isWordEnd: i)
						ifTrue: [
							strm nextPut: (self copyFrom: i0 to: i).
							i0 := i + 1.
							starting := true]
						ifFalse: [starting := false]]].
		starting ifFalse: [strm nextPut: (self copyFrom: i0)]]
]

{ #category : #operations }
CharacterArray >> trimBlanks [
	| start end |
	start := self findFirst: [:char | char isBlank not] ifAbsent: [^''].
	end := self findLast: [:char | char isBlank not].
	^self copyFrom: start to: end
]

{ #category : #parsing }
CharacterArray >> trimComments [
	| input result |
	input := self readStream.
	result := input upTo: $".
	[input skipTo: $"] whileTrue: [result := result , (input upTo: $")].
	^result
]

{ #category : #operations }
CharacterArray >> trimNullEnd [
	| index |
	index := self size.
	[index > 0 and: [(self codeAt: index) = 0]] whileTrue: [index := index - 1].
	^index < self size ifTrue: [self copyFrom: 1 to: index] ifFalse: [self]
]

{ #category : #copying }
CharacterArray >> trimPrefix: aString [
	^(self beginsWith: aString)
		ifTrue: [self allButFirst: aString size]
		ifFalse: [self]
]

{ #category : #copying }
CharacterArray >> trimTail: aString [
	^(self endsWith: aString)
		ifTrue: [self allButLast: aString size]
		ifFalse: [self]
]

{ #category : #accessing }
CharacterArray >> uLongAtOffset: offset [
	| low high |
	low := self uShortAtOffset: offset.
	high := self uShortAtOffset: offset + 2.
	high := high bitShift: 16.
	^high + low
]

{ #category : #converting }
CharacterArray >> unaccented [
	"
	'áéíóúñü' unaccented
	"
	^self asWideString unaccented asAnsi
]

{ #category : #converting }
CharacterArray >> unformatted [
	^self
]

{ #category : #parsing }
CharacterArray >> upTo: aCharacter [
	| index |
	index := self findFirst: [:ch | ch = aCharacter] ifAbsent: [self size + 1].
	^self copyFrom: 1 to: index - 1
]

{ #category : #private }
CharacterArray >> uShortAtOffset: anInteger [
	| size index lo hi |
	size := self basicSize.
	index := anInteger + 1.
	lo := index > size ifTrue: [0] ifFalse: [self byteAt: index].
	hi := index + 1 > size ifTrue: [0] ifFalse: [self byteAt: index + 1].
	^(hi bitShift: 8) + lo
]

{ #category : #services }
CharacterArray >> withArticle [
	^self article , ' ' , self
]

{ #category : #'gui support' }
CharacterArray >> withCrs [
	| copy |
	copy := self copy.
	copy withIndexDo: [:ci :i | ci = $\ ifTrue: [copy at: i put: Cr]].
	^copy
]

{ #category : #copying }
CharacterArray >> withoutCrLf [
	| read blank |
	read := self readStream.
	blank := false.
	^self class streamContents: [:strm | 
		[read atEnd] whileFalse: [| c ch |
			ch := read next.
			(ch isCr or: [ch = Lf])
				ifTrue: [blank ifFalse: [c := Space]]
				ifFalse: [c := ch].
			c notNil ifTrue: [
				strm nextPut: c.
				blank := c isBlank]]]
]

{ #category : #copying }
CharacterArray >> withoutLineEndings [
	| read blank |
	read := self readStream.
	blank := false.
	^self class streamContents: [:strm | 
		[read atEnd] whileFalse: [| c ch |
			ch := read next.
			(ch = Cr or: [ch = Lf])
				ifTrue: [blank ifFalse: [c := Space]]
				ifFalse: [c := ch].
			c notNil ifTrue: [
				strm nextPut: c.
				blank := c isBlank]]]
]

{ #category : #copying }
CharacterArray >> withoutSeparators [
	^self reject: [:c | c isBlank]
]

{ #category : #unix }
CharacterArray >> withUnixEOL [
	| size left replace right |
	size := self size.
	size = 0 ifTrue: [^''].
	left := self at: size.
	right := self at: 1.
	replace := [:char | char = Cr ifTrue: [Lf] ifFalse: [char]].
	^String streamContents: [:stream | 
		1 to: self size - 1 do: [:i | 
			left := self at: i + 1.
			(right = Cr and: [left = Lf])
				ifFalse: [stream nextPut: (replace value: right)].
			right := left].
		stream nextPut: (replace value: left)]
]

