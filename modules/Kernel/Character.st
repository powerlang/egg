"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Character,
	#superclass : #Magnitude,
	#instVars : [
		'value'
	],
	#classVars : [
		'ByteCharacters'
	],
	#category : #Kernel
}

{ #category : #'named characters' }
Character class >> ampersand [
	^$&
]

{ #category : #'named characters' }
Character class >> backspace [
	^self value: 8
]

{ #category : #'named characters' }
Character class >> backtick [
	^$`
]

{ #category : #'instance creation' }
Character class >> bee [
	^$🐝
]

{ #category : #'named characters' }
Character class >> belongs [
	^$∊
]

{ #category : #'named characters' }
Character class >> bullet [
	^Character value: 8226
]

{ #category : #'named characters' }
Character class >> comma [
	^$,
]

{ #category : #'named characters' }
Character class >> copyright [
	^$ⓒ
]

{ #category : #'named characters' }
Character class >> cr [
	^Cr
]

{ #category : #services }
Character class >> digitValue: anInteger [
	| n offset |
	n := anInteger asInteger.
	offset := n < 10 ifTrue: [48] ifFalse: [55].
	^self value: n + offset
]

{ #category : #'named characters' }
Character class >> dollar [
	^$$
]

{ #category : #'named characters' }
Character class >> doubleQuote [
	^$"
]

{ #category : #'named characters' }
Character class >> downArrow [
	^self value: 8595
]

{ #category : #'named characters' }
Character class >> ellipsis [
	^$…
]

{ #category : #'named characters' }
Character class >> emdash [
	^Emdash
]

{ #category : #'named characters' }
Character class >> emspace [
	^Character value: 8195
]

{ #category : #'named characters' }
Character class >> endash [
	^Endash
]

{ #category : #'named characters' }
Character class >> enspace [
	^Character value: 8194
]

{ #category : #'named characters' }
Character class >> equal [
	^$=
]

{ #category : #'named characters' }
Character class >> escape [
	^self value: 27
]

{ #category : #'named characters' }
Character class >> exclamation [
	^$!
]

{ #category : #'named characters' }
Character class >> exists [
	^$∃
]

{ #category : #'named characters' }
Character class >> ff [
	^self value: 12
]

{ #category : #'named characters' }
Character class >> forAll [
	^$∀
]

{ #category : #'named characters' }
Character class >> ge [
	^self value: 16r2265
]

{ #category : #'named characters' }
Character class >> greaterThan [
	^$>
]

{ #category : #initialization }
Character class >> initializeNamedCharacters [
	"
	Character initializeNamedCharacters
	"
	| named |
	named := self addNamespaceAs: #NamedCharacters.
	named
		at: #Bell put: 7 asCharacter;
		at: #Bs put: 8 asCharacter;
		at: #Tab put: 9 asCharacter;
		at: #Lf put: 10 asCharacter;
		at: #Ff put: 12 asCharacter;
		at: #Cr put: 13 asCharacter;
		at: #Esc put: 27 asCharacter;
		at: #Space put: 32 asCharacter;
		at: #Del put: 127 asCharacter;
		at: #TimerTick put: 253 asCharacter;
		at: #Emdash put: 8212 asCharacter;
		at: #Endash put: 8211 asCharacter;
		at: #Emspace put: Character emspace;
		at: #Enspace put: Character enspace;
		at: #Qmspace put: Character qmspace;
		at: #Bullet put: Character bullet;
		at: #Lquote put: Character lquote;
		at: #Rquote put: Character rquote;
		at: #Ldblquote put: Character ldblquote;
		at: #Rdblquote put: Character rdblquote
]

{ #category : #initialization }
Character class >> initializeCharacters [
	ByteCharacters := (0 to: 255) collect: [:i | super new setValue: i]
]

{ #category : #initialization }
Character class >> initializeLatin1Tables [
	order := #[0x01 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x22 0x23 0x24 0x25 0x26 0x0B 0x0C 0x0D 0x0E 0x0F 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x20 0x27 0x28 0x29 0x2A 0x2B 0x2C 0x1E 0x2D 0x2E 0x2F 0x4C 0x30 0x1F 0x31 0x32 0x5D 0x61 0x63 0x65 0x67 0x68 0x69 0x6A 0x6B 0x6C 0x33 0x34 0x4D 0x4E 0x4F 0x35 0x36 0x6D 0x7E 0x81 0x85 0x89 0x92 0x94 0x96 0x99 0xA3 0xA4 0xA7 0xA8 0xAB 0xAE 0xBD 0xBF 0xC1 0xC3 0xC6 0xCA 0xD4 0xD6 0xD8 0xDB 0xE0 0x37 0x38 0x39 0x3A 0x3B 0x3C 0x6D 0x7E 0x81 0x85 0x89 0x92 0x94 0x96 0x99 0xA3 0xA4 0xA7 0xA8 0xAB 0xAE 0xBD 0xBF 0xC1 0xC3 0xC6 0xCA 0xD4 0xD6 0xD8 0xDB 0xE0 0x3D 0x3E 0x3F 0x40 0x1D 0x01 0x01 0x01 0x00 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x00 0x01 0x01 0x00 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x01 0x21 0x41 0x48 0x49 0x4A 0x4B 0x42 0x55 0x43 0x56 0x6F 0x51 0x57 0x02 0x58 0x44 0x59 0x50 0x64 0x66 0x45 0x5A 0x5B 0x5C 0x46 0x62 0xB0 0x52 0x5E 0x5F 0x60 0x47 0x73 0x70 0x74 0x79 0x77 0x7A 0x7D 0x82 0x8D 0x8B 0x8F 0x90 0x9C 0x9B 0x9F 0xA0 0x86 0xAC 0xB4 0xB2 0xB6 0xB9 0xB8 0x53 0xBC 0xCE 0xCD 0xD0 0xD2 0xDC 0xC9 0xC5 0x73 0x70 0x74 0x79 0x77 0x7A 0x7D 0x82 0x8D 0x8B 0x8F 0x90 0x9D 0x9B 0x9F 0xA1 0x86 0xAD 0xB4 0xB2 0xB6 0xB9 0xB8 0x54 0xBC 0xCE 0xCD 0xD0 0xD2 0xDC 0xC9 0xDE].
	uppercases := #[0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x0B 0x0C 0x0D 0x0E 0x0F 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x1D 0x1E 0x1F 0x20 0x21 0x22 0x23 0x24 0x25 0x26 0x27 0x28 0x29 0x2A 0x2B 0x2C 0x2D 0x2E 0x2F 0x30 0x31 0x32 0x33 0x34 0x35 0x36 0x37 0x38 0x39 0x3A 0x3B 0x3C 0x3D 0x3E 0x3F 0x40 0x41 0x42 0x43 0x44 0x45 0x46 0x47 0x48 0x49 0x4A 0x4B 0x4C 0x4D 0x4E 0x4F 0x50 0x51 0x52 0x53 0x54 0x55 0x56 0x57 0x58 0x59 0x5A 0x5B 0x5C 0x5D 0x5E 0x5F 0x60 0x41 0x42 0x43 0x44 0x45 0x46 0x47 0x48 0x49 0x4A 0x4B 0x4C 0x4D 0x4E 0x4F 0x50 0x51 0x52 0x53 0x54 0x55 0x56 0x57 0x58 0x59 0x5A 0x7B 0x7C 0x7D 0x7E 0x7F 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xA0 0xA1 0xA2 0xA3 0xA4 0xA5 0xA6 0xA7 0xA8 0xA9 0xAA 0xAB 0xAC 0xAD 0xAE 0xAF 0xB0 0xB1 0xB2 0xB3 0xB4 0xB5 0xB6 0xB7 0xB8 0xB9 0xBA 0xBB 0xBC 0xBD 0xBE 0xBF 0xC0 0xC1 0xC2 0xC3 0xC4 0xC5 0xC6 0xC7 0xC8 0xC9 0xCA 0xCB 0xCC 0xCD 0xCE 0xCF 0xD0 0xD1 0xD2 0xD3 0xD4 0xD5 0xD6 0xD7 0xD8 0xD9 0xDA 0xDB 0xDC 0xDD 0xDE 0xDF 0xC0 0xC1 0xC2 0xC3 0xC4 0xC5 0xC6 0xC7 0xC8 0xC9 0xCA 0xCB 0xCC 0xCD 0xCE 0xCF 0xD0 0xD1 0xD2 0xD3 0xD4 0xD5 0xD6 0xF7 0xD8 0xD9 0xDA 0xDB 0xDC 0xDD 0xDE 0x9F] collect: [:v | Character value: v].
	lowercases := #[0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x0B 0x0C 0x0D 0x0E 0x0F 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x1D 0x1E 0x1F 0x20 0x21 0x22 0x23 0x24 0x25 0x26 0x27 0x28 0x29 0x2A 0x2B 0x2C 0x2D 0x2E 0x2F 0x30 0x31 0x32 0x33 0x34 0x35 0x36 0x37 0x38 0x39 0x3A 0x3B 0x3C 0x3D 0x3E 0x3F 0x40 0x61 0x62 0x63 0x64 0x65 0x66 0x67 0x68 0x69 0x6A 0x6B 0x6C 0x6D 0x6E 0x6F 0x70 0x71 0x72 0x73 0x74 0x75 0x76 0x77 0x78 0x79 0x7A 0x5B 0x5C 0x5D 0x5E 0x5F 0x60 0x61 0x62 0x63 0x64 0x65 0x66 0x67 0x68 0x69 0x6A 0x6B 0x6C 0x6D 0x6E 0x6F 0x70 0x71 0x72 0x73 0x74 0x75 0x76 0x77 0x78 0x79 0x7A 0x7B 0x7C 0x7D 0x7E 0x7F 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xA0 0xA1 0xA2 0xA3 0xA4 0xA5 0xA6 0xA7 0xA8 0xA9 0xAA 0xAB 0xAC 0xAD 0xAE 0xAF 0xB0 0xB1 0xB2 0xB3 0xB4 0xB5 0xB6 0xB7 0xB8 0xB9 0xBA 0xBB 0xBC 0xBD 0xBE 0xBF 0xE0 0xE1 0xE2 0xE3 0xE4 0xE5 0xE6 0xE7 0xE8 0xE9 0xEA 0xEB 0xEC 0xED 0xEE 0xEF 0xF0 0xF1 0xF2 0xF3 0xF4 0xF5 0xF6 0xD7 0xF8 0xF9 0xFA 0xFB 0xFC 0xFD 0xFE 0xDF 0xE0 0xE1 0xE2 0xE3 0xE4 0xE5 0xE6 0xE7 0xE8 0xE9 0xEA 0xEB 0xEC 0xED 0xEE 0xEF 0xF0 0xF1 0xF2 0xF3 0xF4 0xF5 0xF6 0xF7 0xF8 0xF9 0xFA 0xFB 0xFC 0xFD 0xFE 0xFF].
	
	self 
		classVarNamed: #Latin1Order put: order;
		classVarNamed: #Latin1Uppercases put: uppercases;
		classVarNamed: #Latin1Lowercases put: lowercases
]

{ #category : #'named characters' }
Character class >> italicA [
	^Character value: 16r1D44E
]

{ #category : #'named characters' }
Character class >> ldblquote [
	^Character value: 8220
]

{ #category : #'named characters' }
Character class >> le [
	^self value: 16r2264
]

{ #category : #'named characters' }
Character class >> leftArrow [
	^self value: 16r2190
]

{ #category : #'named characters' }
Character class >> lessThan [
	^$<
]

{ #category : #'named characters' }
Character class >> lf [
	^self value: 10
]

{ #category : #'named characters' }
Character class >> lquote [
	^Character value: 8216
]

{ #category : #'named characters' }
Character class >> minus [
	^$-
]

{ #category : #'named characters' }
Character class >> muchGreater [
	^$≫
]

{ #category : #'named characters' }
Character class >> namedCharacters [
	^NamedCharacters
]

{ #category : #'instance creation' }
Character class >> new [
	^self shouldNotImplement
]

{ #category : #'named characters' }
Character class >> null [
	^self value: 0
]

{ #category : #'named characters' }
Character class >> oplus [
	"
	Character tensor
	"
	^8853 asCharacter
]

{ #category : #'named characters' }
Character class >> period [
	^$.
]

{ #category : #'named characters' }
Character class >> qmspace [
	^Character value: 8197
]

{ #category : #'named characters' }
Character class >> rdblquote [
	^Character value: 8221
]

{ #category : #'named characters' }
Character class >> rightArrow [
	^self value: 16r2192
]

{ #category : #'named characters' }
Character class >> rquote [
	^Character value: 8217
]

{ #category : #'named characters' }
Character class >> semicolon [
	^$;
]

{ #category : #'named characters' }
Character class >> singleQuote [
	^$'
]

{ #category : #inquiries }
Character class >> sizeInBytes [
	^1
]

{ #category : #'named characters' }
Character class >> space [
	^$ 
]

{ #category : #'named characters' }
Character class >> tab [
	^self value: 9
]

{ #category : #'named characters' }
Character class >> tensor [
	"
	Character tensor
	"
	^8855 asCharacter
]

{ #category : #'named characters' }
Character class >> underscore [
	^$_
]

{ #category : #'named characters' }
Character class >> upArrow [
	^self value: 16r2191
]

{ #category : #'instance creation' }
Character class >> value: anInteger [
	^(anInteger >= 0 and: [anInteger + 1 <= ByteCharacters _size])
		ifTrue: [ByteCharacters _basicAt: anInteger + 1]
		ifFalse: [Character basicNew setValue: anInteger]
]

{ #category : #arithmetic }
Character >> - aMagnitude [
	| subtraction |
	subtraction := aMagnitude isCharacter
		ifTrue: [aMagnitude asInteger]
		ifFalse: [aMagnitude].
	^value - subtraction
]

{ #category : #converting }
Character >> , characterOrString [
	^self asString , characterOrString asString
]

{ #category : #arithmetic }
Character >> + aMagnitude [
	| addend |
	addend := aMagnitude isCharacter
		ifTrue: [aMagnitude asInteger]
		ifFalse: [aMagnitude].
	^self class value: value + addend
]

{ #category : #comparing }
Character >> < aCharacter [
	| anotherValue |
	anotherValue := aCharacter codePoint.
	(value < 256 and: [anotherValue < 256]) ifTrue: [^(Latin1Order at: value) < (Latin1Order at: anotherValue)].
	^UnicodeLibrary isCodePoint: value lessThan: anotherValue
]

{ #category : #comparing }
Character >> <~ aMagnitude [
	^self <= aMagnitude
]

{ #category : #comparing }
Character >> <= aCharacter [
	| anotherValue |
	anotherValue := aCharacter codePoint.
	(value < 256 and: [anotherValue < 256]) ifTrue: [^(Latin1Order at: value) <= (Latin1Order at: anotherValue)].
	^UnicodeLibrary isCodePoint: value lessThanOrEqualTo: anotherValue
]

{ #category : #comparing }
Character >> = aCharacter [
	^self class == aCharacter class and: [value = aCharacter codePoint]
]

{ #category : #comparing }
Character >> > aCharacter [
	| anotherValue |
	anotherValue := aCharacter codePoint.
	(value < 256 and: [anotherValue < 256]) ifTrue: [^(Latin1Order at: value) > (Latin1Order at: anotherValue)].
	^UnicodeLibrary isCodePoint: value greaterThan: anotherValue
]

{ #category : #comparing }
Character >> >= aCharacter [
	| anotherValue |
	anotherValue := aCharacter codePoint.
	(value < 256 and: [anotherValue < 256]) ifTrue: [^(Latin1Order at: value) >= (Latin1Order at: anotherValue)].
	^UnicodeLibrary isCodePoint: value greaterThanOrEqualTo: anotherValue
]

{ #category : #converting }
Character >> asCharacter [
	^self
]

{ #category : #converting }
Character >> asInteger [
	^value
]

{ #category : #operations }
Character >> asLowercase [
	value < 256 ifTrue: [^Latin1Lowercases at: value + 1].
	^UnicodeLibrary lowercaseOf: self
]

{ #category : #converting }
Character >> asParameter [
	^self codePoint
]

{ #category : #converting }
Character >> asString [
	| class |
	class := self isByteCharacter ifTrue: [String] ifFalse: [WideString].
	^class with: self
]

{ #category : #operations }
Character >> asUppercase [
	value < 256 ifTrue: [^Latin1Uppercases at: value + 1].
	^UnicodeLibrary uppercaseOf: self
]

{ #category : #comparing }
Character >> between: min and: max [
	^min codePoint <= value and: [value <= max codePoint]
]

{ #category : #printing }
Character >> canBePrintedAsLiteral [
	^true
]

{ #category : #accessing }
Character >> codePoint [
	^value
]

{ #category : #copying }
Character >> deepCopy [
	^self
]

{ #category : #accessing }
Character >> digitValue [
	self isDigit ifTrue: [^value - 48].
	self isAsciiLetter ifFalse: [self error: 'Cannot calculate digitValue'].
	value > 96 ifTrue: [^value - 87].
	^value - 55
]

{ #category : #comparing }
Character >> hash [
	^value hash
]

{ #category : #accessing }
Character >> highByte [
	^value bitShift: -8
]

{ #category : #testing }
Character >> isAlphanumeric [
	value < 256 ifTrue: [^self isLetter or: [self isDigit]].
	^UnicodeLibrary isAlphanumeric: self
]

{ #category : #testing }
Character >> isAlphaNumericOrUnderscore [
	^self isDigit or: [self isLetter] or: [self = $_]
]

{ #category : #testing }
Character >> isAsciiLetter [
	value < 65 ifTrue: [^false].
	value < 91 ifTrue: [^true].
	value = 95 ifTrue: [^true].
	value < 97 ifTrue: [^false].
	value < 123 ifTrue: [^true].
	^false.
]

{ #category : #testing }
Character >> isAsterisk [
	^value = 42
]

{ #category : #testing }
Character >> isBackslash [
	^value = 92
]

{ #category : #testing }
Character >> isBacktick [
	^value = 96
]

{ #category : #testing }
Character >> isBlank [
	value <= 32 ifTrue: [^true].
	value = 160 ifTrue: [^true].
	value < 16r2000 ifTrue: [^false].
	value < 16r200C ifTrue: [^true].
	value = 16r202F ifTrue: [^true].
	value = 16r205F ifTrue: [^true].
	value = 16r3000 ifTrue: [^true].
	^false
]

{ #category : #testing }
Character >> isByteCharacter [
	^value < 256
]

{ #category : #testing }
Character >> isCharacter [
	^true
]

{ #category : #testing }
Character >> isCircumflex [
	^value = 94
]

{ #category : #testing }
Character >> isColon [
	^value = 58
]

{ #category : #testing }
Character >> isCr [
	^value = 13
]

{ #category : #testing }
Character >> isDigit [
	^value >= 48 and: [value <= 57]
]

{ #category : #testing }
Character >> isHexDigit [
	^self isDigit or: [self between: $a and: $f] or: [self between: $A and: $F]
]

{ #category : #testing }
Character >> isDollar [
	^value = 36
]

{ #category : #testing }
Character >> isDollarSign [
	^value = 36
]

{ #category : #testing }
Character >> isDot [
	^value = 46
]

{ #category : #testing }
Character >> isDoubleQuote [
	^value = 34
]

{ #category : #testing }
Character >> isEndOfLine [
	^value = 13 | (value = 10)
]

{ #category : #testing }
Character >> isEsc [
	^self = self class escape
]

{ #category : #testing }
Character >> isFixedObject [
	^value < 256
]

{ #category : #testing }
Character >> isGreaterThan [
	^value = 62
]

{ #category : #testing }
Character >> isHash [
	^value = 35
]

{ #category : #testing }
Character >> isIdentifierCharacter [
	('$:_' includes: self) ifTrue: [^true].
	^self isAlphanumeric
]

{ #category : #testing }
Character >> isLeftBracket [
	^value = 91
]

{ #category : #testing }
Character >> isLeftCurlyBracket [
	^value = 123
]

{ #category : #testing }
Character >> isLessThan [
	^value = 60
]

{ #category : #testing }
Character >> isLetter [
	self isAsciiLetter ifTrue: [^true].
	value < 128 ifTrue: [^false].
	value < 256 ifTrue: [ | byte bit |
		byte := #[0x0 0x0 0x0 0x0 0x0 0x4 0x20 0x4 0xFF 0xFF 0x7F 0xFF 0xFF 0xFF 0x7F 0xFF] at: ((value - 128) bitShift: -3) + 1.
		bit := (value bitAnd: 7) + 1.
		^(byte bitAt: bit) == 1].
	^UnicodeLibrary isLetter: self
]

{ #category : #testing }
Character >> isLf [
	^value = 10
]

{ #category : #testing }
Character >> isLowercase [
	value < 256 ifTrue: [^(Latin1Uppercases at: value + 1) != self].
	^UnicodeLibrary isLowercase: self
]

{ #category : #testing }
Character >> isMinus [
	^value = 45
]

{ #category : #testing }
Character >> isNull [
	^value = 0
]

{ #category : #testing }
Character >> isNumeric [
	value < 49 ifTrue: [^false].
	value <= 58 ifTrue: [^true].
	value < 256 ifTrue: [^value == 179 or: [value == 180 or: [value == 186]]].
	^UnicodeLibrary isNumeric: self
]

{ #category : #testing }
Character >> isPipe [
	^value = 124
]

{ #category : #testing }
Character >> isPlus [
	^value = 43
]

{ #category : #testing }
Character >> isPunctuationMark [
	self = $. ifTrue: [^true].
	self = $; ifTrue: [^true].
	self = $: ifTrue: [^true].
	self = $_ ifTrue: [^true].
	self = $, ifTrue: [^true].
	self = $! ifTrue: [^true].
	self = $? ifTrue: [^true].
	^false
]

{ #category : #testing }
Character >> isQuestionMark [
	^value = 63
]

{ #category : #testing }
Character >> isRightBracket [
	^value = 93
]

{ #category : #testing }
Character >> isRightCurlyBracket [
	^value = 125
]

{ #category : #testing }
Character >> isRightParenthesis [
	^value = 41
]

{ #category : #testing }
Character >> isSemiColon [
	^value = 59
]

{ #category : #testing }
Character >> isSeparator [
	self = Space ifTrue: [^true].
	self = Tab ifTrue: [^true].
	self = Cr ifTrue: [^true].
	self = Lf ifTrue: [^true].
	self = Ff ifTrue: [^true].
	^false
]

{ #category : #testing }
Character >> isSingleQuote [
	^value = 39
]

{ #category : #testing }
Character >> isSpace [
	^value = 32
]

{ #category : #testing }
Character >> isTab [
	^value = 9
]

{ #category : #testing }
Character >> isUnderscore [
	^value = 95
]

{ #category : #testing }
Character >> isUppercase [
	value < 256 ifTrue: [^(Latin1Lowercases at: value + 1) != self].
	^UnicodeLibrary isUppercase: self
]

{ #category : #testing }
Character >> isVowel [
	^'aAeEiIoOuU' includes: self
]

{ #category : #accessing }
Character >> lowByte [
	^value bitAnd: 16rFF
]

{ #category : #accessing }
Character >> numericValue [
	self isDigit ifTrue: [^value - 48].
	self isAsciiLetter ifFalse: [self error: 'Cannot calculate digitValue'].
	value > 96 ifTrue: [^value - 87].
	^value - 55
]

{ #category : #printing }
Character >> printOn: aStream [
	self isByteCharacter ifFalse: [aStream beWide].
	aStream nextPut: $$; nextPut: self
]

{ #category : #private }
Character >> setValue: anInteger [
	value := anInteger
]

{ #category : #copying }
Character >> shallowCopy [
	^self
]

{ #category : #services }
Character >> split: aString [
	^aString substringsSplitBy: self
]

{ #category : #printing }
Character >> storeOn: aStream [
	self printOn: aStream
]

{ #category : #converting }
Character >> storeUTF8On: aStream [
	"
	16r800 asCharacter utf8
	"
	| b1 b2 b3 b4 |
	value < 16r80 ifTrue: [^aStream nextBytePut: value].
	value < 16r800 ifTrue: [
		b1 := value bitShift: -6.
		b1 := b1 bitOr: 16rC0.
		b2 := value bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		^aStream nextBytePut: b1; nextBytePut: b2].
	value < 16r10000 ifTrue: [
		b1 := value bitShift: -12.
		b1 := b1 bitOr: 16rE0.
		b2 := value bitShift: -6.
		b2 := b2 bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		b3 := value bitAnd: 16r3F.
		b3 := b3 bitOr: 16r80.
		^aStream
			nextBytePut: b1;
			nextBytePut: b2;
			nextBytePut: b3].
	b1 := value bitShift: -18.
	b1 := b1 bitOr: 16rF0.
	b2 := value bitShift: -12.
	b2 := b2 bitAnd: 16r3F.
	b2 := b2 bitOr: 16r80.
	b3 := value bitShift: -6.
	b3 := b3 bitAnd: 16r3F.
	b3 := b3 bitOr: 16r80.
	b4 := value bitAnd: 16r3F.
	b4 := b4 bitOr: 16r80.
	^aStream
		nextBytePut: b1;
		nextBytePut: b2;
		nextBytePut: b3;
		nextBytePut: b4
]

{ #category : #converting }
Character >> utf8 [
	"
	16r800 asCharacter utf8
	"
	^UTF8 current encodeCharacter: self
]

