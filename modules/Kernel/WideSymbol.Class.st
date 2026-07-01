'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #WideSymbol category: #Kernel!
Symbol subclass: #WideSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!WideSymbol commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!WideSymbol methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aString
	^UTF16 current isString: self lessThanOrEqualTo: aString
! !

!WideSymbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asByteCharacters
	| n result |
	n := self size.
	result := Symbol new: n.
	1 to: n do: [:i | | code char |
		code := self codeAt: i.
		char := code < 256 ifTrue: [code] ifFalse: [$? asInteger].
		result byteAt: i put: char].
	^result
! !

!WideSymbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asLowercase
	^UTF16 current lowercaseOf: self
! !

!WideSymbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asString
	| n string |
	n := self size.
	string := WideString new: n.
	^string replaceFrom: 1 to: n with: self
! !

!WideSymbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asUppercase
	^UTF16 current uppercaseOf: self
! !

!WideSymbol methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asWideSymbol
	^self
! !

!WideSymbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	| cp |
	cp := self checkIndex: index; codeAt: index.
	^Character value: cp
! !

!WideSymbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index putCode: codePoint
	^self
		checkIndex: index;
		uLongAtOffset: index - 1 * 4 put: codePoint
! !

!WideSymbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: index
	| cp |
	cp := self codeAt: index.
	^Character value: cp
! !

!WideSymbol methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicSize
	^self _size
! !

!WideSymbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
codeAt: index
	^self uLongAtOffset: index - 1 * 4
! !

!WideSymbol methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isByteCompliant
	^false
! !

!WideSymbol methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWide
	^true
! !

!WideSymbol methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWideSymbol
	^true
! !

!WideSymbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^self _size // 4
! !

!WideSymbol methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^self size * 4
! !

!WideSymbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
species
	^WideString
! !

!WideSymbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
td1
	| m td1 |
	m := self size.
	td1 := Dictionary new: m.
	m to: 1 by: -1 do: [:i | | code |
		code := self uLongAtOffset: i - 1 * 4.
		td1 at: code + 1 ifAbsentPut: [m - i + 1]].
	^td1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WideSymbol class' category: #Kernel!
WideSymbol class
	instanceVariableNames: ''!

!WideSymbol class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
findInterned: aString
	| symbol string |
	string := aString reduced.
	string == aString ifFalse: [^super findInterned: string].
	symbol := aString bytes changeClassTo: self.
	^SymbolTable lookup: symbol
! !

!WideSymbol class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
intern: aString
	| symbol canonical |
	aString isByteCompliant ifTrue: [^aString reduced asSymbol].
	symbol := aString bytes changeClassTo: self.
	canonical := SymbolTable lookup: symbol.
	canonical == nil ifTrue: [^SymbolTable add: symbol].
	^canonical
! !


