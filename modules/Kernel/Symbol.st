"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Symbol,
	#superclass : #CharacterArray,
	#type : #bytes,
	#classVars : [
		'SymbolTable'
	],
	#category : #Kernel
}

{ #category : #accessing }
Symbol class >> findInterned: aString [
	| symbol |
	symbol := aString bytes changeClassTo: Symbol.
	^SymbolTable lookup: symbol
]

{ #category : #'instance creation' }
Symbol class >> fromBytes: aByteArray [
	| n string |
	n := aByteArray sizeInBytes.
	string := self basicNew: n.
	^string replaceBytesFrom: 1 to: n with: aByteArray startingAt: 1
]

{ #category : #initialization }
Symbol class >> initializeSymbolTable [
	| policy set |
	self == Symbol ifFalse: [^self].
	policy := HashTablePolicy new
		storesAssociations: false;
		bucketClass: OpenHashTable;
		useStringHash.
	set := Set new: 5000 using: policy.
	SymbolTable := set
]

{ #category : #accessing }
Symbol class >> intern: aString [
	| symbol existing |
	aString isUnicode ifTrue: [^WideSymbol intern: aString].
	symbol := aString bytes changeClassTo: self.
	existing := SymbolTable lookup: symbol.
	existing == nil ifTrue: [
		existing := symbol.
		SymbolTable add: existing].
	^existing
]

{ #category : #'instance creation' }
Symbol class >> new: ignoreArgument [
	^self shouldNotImplement
]

{ #category : #private }
Symbol class >> startUp [
	SymbolTable beWeak
]

{ #category : #private }
Symbol class >> symbolTable [
	^SymbolTable
]

{ #category : #operations }
Symbol >> , aString [
	^self asString , aString
]

{ #category : #comparing }
Symbol >> <= aSymbol [
	aSymbol isSymbol ifFalse: [^self error: 'cannot compare'].
	^self asString <= aSymbol asString
]

{ #category : #accessing }
Symbol >> arity [
	| last first |
	self isEmpty ifTrue: [^0].
	last := self last.
	last isAlphanumeric ifTrue: [^0].
	last = $: ifTrue: [
		first := self first.
		^(first = $_ or: [first isAlphanumeric])
			ifTrue: [self occurrencesOf: $:]
			ifFalse: [1]].
	last = $_ ifTrue: [^0].
	^1
]

{ #category : #converting }
Symbol >> asAnsi [
	^self
]

{ #category : #converting }
Symbol >> asByteArray [
	| array |
	array := ByteArray new: self sizeInBytes.
	^array replaceBytesFrom: 1 to: array size with: self startingAt: 1
]

{ #category : #converting }
Symbol >> asSelector [
	^self
]

{ #category : #converting }
Symbol >> asString [
	| string |
	string := String new: self size.
	^string replaceFrom: 1 to: self size with: self
]

{ #category : #converting }
Symbol >> asSymbol [
	^self
]

{ #category : #converting }
Symbol >> asWideString [
	^self asString asWideString
]

{ #category : #accessing }
Symbol >> at: anInteger put: aCharacter [
	^self shouldNotImplement
]

{ #category : #accessing }
Symbol >> atValid: anInteger [
	^self characterAtValid: anInteger
]

{ #category : #comparing }
Symbol >> basicHash [
	^self hash
]

{ #category : #accessing }
Symbol >> basicSize [
	^self _size - 1
]

{ #category : #converting }
Symbol >> capitalized [
	^self asString capitalized
]

{ #category : #accessing }
Symbol >> characterSize [
	^1
]

{ #category : #private }
Symbol >> codeAt: i [
	^self byteAt: i
]

{ #category : #copying }
Symbol >> deepCopy [
	^self
]

{ #category : #services }
Symbol >> doubleQuoted [
	^self asString doubleQuoted
]

{ #category : #evaluating }
Symbol >> evaluateFor: anObject [
	^anObject perform: self
]

{ #category : #evaluating }
Symbol >> evaluateWith: anObject [
	^anObject perform: self
]

{ #category : #evaluating }
Symbol >> evaluateWithArguments: anArray [
	| n args |
	n := anArray size min: self arity + 1.
	args := anArray copyFrom: 2 to: n.
	^anArray first perform: self withArguments: args asArray
]

{ #category : #converting }
Symbol >> existingSymbol [
	^self
]

{ #category : #services }
Symbol >> flushCacheFor: species [
	self errorVMspecific
]

{ #category : #private }
Symbol >> hash [
	| pseudoindex first second third begin middle end current new |
	current := self _basicHash.
	current != 0 ifTrue: [^current].
	pseudoindex := self basicSize - 1.
	pseudoindex < 0 ifTrue: [^0].
	begin := 0.
	middle := (pseudoindex bitAnd: 16rFFFF) // 2.
	end := middle * 2.
	first := (self shortAtOffset: begin) + (256 * (pseudoindex at: 1)).
	second := self shortAtOffset: end.
	third := self shortAtOffset: middle.
	new := first + (second * 4 + third * 4) bitAnd: 16r7FFF.
	self _basicHash: new.
	^new
]

{ #category : #private }
Symbol >> hash16 [
	| seed hash |
	seed := 13131.
	hash := self size.
	self ASSERT: hash = self size.
	1 to: self size do: [:i | | cp |
		cp := self codeAt: i.
		hash := hash * seed + cp bitAnd: 16rFFFF].
	^hash
]

{ #category : #private }
Symbol >> hashDJB [
	| hash |
	hash := 5381.
	1
		to: self size
		do: [:i | hash := ((hash bitShift: 5) bitAnd: 16rFFFF) + hash + (self
			codeAt: i)
			bitAnd: 16rFFFF].
	^((hash bitShift: 5) bitAnd: 16rFFFF) + hash + self size
]

{ #category : #parsing }
Symbol >> indexOfString: aString
from: start
to: stop
td1: anArray [
	| m k |
	m := aString size.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i byte delta |
		i := 1.
		[i <= m and: [(aString at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		byte := self byteAt: k + m.
		delta := (anArray at: byte + 1) ifNil: [m + 1].
		k := k + delta].
	^0
]

{ #category : #testing }
Symbol >> isSymbol [
	^true
]

{ #category : #parsing }
Symbol >> keywords [
	"
	#replace:with: keywords
	"
	self isEmpty ifTrue: [^#()].
	(self noneSatisfy: [:ch | ch isAlphanumeric or: [ch = $_]]) ifTrue: [^{self}].
	self last = $: ifFalse: [^{self}].
	^Array streamContents: [:stream | | reader |
		reader := self asString readStream.
		[reader atEnd] whileFalse: [| keyword |
			keyword := reader throughAll: ':'.
			stream nextPut: keyword]]
]

{ #category : #testing }
Symbol >> normalizeToC [
	"
	do nothing
	"
	
]

{ #category : #converting }
Symbol >> nullTerminated [
	^self asString nullTerminated
]

{ #category : #private }
Symbol >> primitiveReplaceFrom: start to: stop withObject: aCharacter [
	self checkCharacter: aCharacter.
	aCharacter isUnicode
		ifTrue: [self error: 'Strings cannot hold Unicode characters'].
	start to: stop do: [:i | self at: i put: aCharacter].
	^aCharacter
]

{ #category : #printing }
Symbol >> printOn: aStream [
	aStream nextPutAll: self asString
]

{ #category : #replacing }
Symbol >> replaceBytesFrom: byteStart
to: byteStop
with: aVariableByteObject
startingAt: byteRepStart [
	^self shouldNotImplement
]

{ #category : #replacing }
Symbol >> replaceFirst: count with: aCollection [
	^self shouldNotImplement
]

{ #category : #replacing }
Symbol >> replaceFrom: start
to: stop
with: aString
startingAt: position [
	^self shouldNotImplement
]

{ #category : #replacing }
Symbol >> replaceFrom: start to: stop withObject: aCharacter [
	^self shouldNotImplement
]

{ #category : #copying }
Symbol >> shallowCopy [
	^self
]

{ #category : #accessing }
Symbol >> size [
	^self _size - 1
]

{ #category : #accessing }
Symbol >> sizeInBytes [
	^self size
]

{ #category : #private }
Symbol >> species [
	^String
]

{ #category : #printing }
Symbol >> storeOn: aStream [
	aStream nextPut: $#.
	(self isEmpty or: [| first |
		first := self first.
		(first isLetter not and: [first ~= $_])
			or: [self anySatisfy: [:char | char isIdentifierCharacter not]]])
		ifTrue: [
			aStream nextPut: $'.
			self do: [:char | 
				aStream nextPut: char.
				char = $' ifTrue: [aStream nextPut: $']].
			aStream nextPut: $']
		ifFalse: [aStream nextPutAll: self asString]
]

{ #category : #private }
Symbol >> td1 [
	"
	Sunday Algorithm
	ShellDLL current openWebPage: 'http://www.cin.ufpe.br/~paguso/courses/if767/bib/Sunday_1990.pdf'
	"
	| m td1 |
	m := self size.
	td1 := Array new: 256.
	m to: 1 by: -1 do: [:i | | byte j |
		byte := self byteAt: i.
		j := byte + 1.
		(td1 at: j) isNil ifTrue: [td1 at: j put: m - i + 1]].
	^td1
]

{ #category : #evaluating }
Symbol >> value: a value: b [
	^(a perform: self) <= (b perform: self)
]

{ #category : #converting }
Symbol >> writeStream [
	^WriteStringStream on: self
]

