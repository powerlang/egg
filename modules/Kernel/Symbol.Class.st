'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Symbol category: #Kernel!
CharacterArray subclass: #Symbol
	instanceVariableNames: ''
	classVariableNames: 'SymbolTable'
	poolDictionaries: ''
	category: 'Kernel'!
!Symbol commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Symbol methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
, aString
	^self asString , aString
! !

!Symbol methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aSymbol
	aSymbol isSymbol ifFalse: [^self error: 'cannot compare'].
	^self asString <= aSymbol asString
! !

!Symbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arity
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
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asByteArray
	| array |
	array := ByteArray new: self sizeInBytes.
	^array replaceBytesFrom: 1 to: array size with: self startingAt: 1
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asString
	| string |
	string := String new: self size.
	^string replaceFrom: 1 to: self size with: self
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSymbol
	^self
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asWideString
	^self asString asWideString
! !

!Symbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: aCharacter
	^self shouldNotImplement
! !

!Symbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: anInteger
	^self characterAtValid: anInteger
! !

!Symbol methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicHash
	^self hash
! !

!Symbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicSize
	^self _size - 1
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
capitalized
	^self asString capitalized
! !

!Symbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
characterSize
	^1
! !

!Symbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
codeAt: i
	^self byteAt: i
! !

!Symbol methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	^self
! !

!Symbol methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
doubleQuoted
	^self asString doubleQuoted
! !

!Symbol methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateFor: anObject
	^anObject perform: self
! !

!Symbol methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: anObject
	^anObject perform: self
! !

!Symbol methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWithArguments: anArray
	| n args |
	n := anArray size min: self arity + 1.
	args := anArray copyFrom: 2 to: n.
	^anArray first perform: self withArguments: args asArray
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
existingSymbol
	^self
! !

!Symbol methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
flushCacheFor: species
	self errorVMspecific
! !

!Symbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	| pseudoindex first second third begin middle end current new |
	current := self _basicHash.
	current !!= 0 ifTrue: [^current].
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
! !

!Symbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash16
	| seed hash |
	seed := 13131.
	hash := self size.
	self ASSERT: hash = self size.
	1 to: self size do: [:i | | cp |
		cp := self codeAt: i.
		hash := hash * seed + cp bitAnd: 16rFFFF].
	^hash
! !

!Symbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashDJB
	| hash |
	hash := 5381.
	1
		to: self size
		do: [:i | hash := ((hash bitShift: 5) bitAnd: 16rFFFF) + hash + (self
			codeAt: i)
			bitAnd: 16rFFFF].
	^((hash bitShift: 5) bitAnd: 16rFFFF) + hash + self size
! !

!Symbol methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfString: aString from: start to: stop td1: anArray
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
! !

!Symbol methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSymbol
	^true
! !

!Symbol methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
keywords
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
! !

!Symbol methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
normalizeToC
	"
	do nothing
	"
	
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
nullTerminated
	^self asString nullTerminated
! !

!Symbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveReplaceFrom: start to: stop withObject: aCharacter
	self checkCharacter: aCharacter.
	aCharacter isByteCharacter
		ifFalse: [self error: 'Byte symbols cannot hold non-latin1 characters'].
	start to: stop do: [:i | self at: i put: aCharacter].
	^aCharacter
! !

!Symbol methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: self asString
! !

!Symbol methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceBytesFrom: byteStart to: byteStop with: aVariableByteObject startingAt: byteRepStart
	^self shouldNotImplement
! !

!Symbol methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFirst: count with: aCollection
	^self shouldNotImplement
! !

!Symbol methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop with: aString startingAt: position
	^self shouldNotImplement
! !

!Symbol methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop withObject: aCharacter
	^self shouldNotImplement
! !

!Symbol methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
shallowCopy
	^self
! !

!Symbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^self _size - 1
! !

!Symbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^self size
! !

!Symbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
species
	^String
! !

!Symbol methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
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
! !

!Symbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
td1
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
! !

!Symbol methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: a value: b
	^(a perform: self) <= (b perform: self)
! !

!Symbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
writeStream
	^WriteStringStream on: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Symbol class' category: #Kernel!
Symbol class
	instanceVariableNames: 'SymbolTable'!

!Symbol class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
findInterned: aString
	| symbol |
	symbol := aString bytes changeClassTo: Symbol.
	^SymbolTable lookup: symbol
! !

!Symbol class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromBytes: aByteArray
	| n string |
	n := aByteArray sizeInBytes.
	string := self basicNew: n.
	^string replaceBytesFrom: 1 to: n with: aByteArray startingAt: 1
! !

!Symbol class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeSymbolTable
	| policy set |
	self == Symbol ifFalse: [^self].
	policy := HashTablePolicy new
		storesAssociations: false;
		bucketClass: OpenHashTable;
		useStringHash.
	set := Set new: 5000 using: policy.
	SymbolTable := set
! !

!Symbol class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
intern: aString
	| symbol existing |
	aString isWide ifTrue: [^WideSymbol intern: aString].
	symbol := aString bytes changeClassTo: self.
	existing := SymbolTable lookup: symbol.
	existing == nil ifTrue: [
		existing := symbol.
		SymbolTable add: existing].
	^existing
! !

!Symbol class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: ignoreArgument
	^self shouldNotImplement
! !

!Symbol class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
startUp
	SymbolTable beWeak
! !

!Symbol class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
symbolTable
	^SymbolTable
! !


