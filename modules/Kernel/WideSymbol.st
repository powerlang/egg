"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #WideSymbol,
	#superclass : #Symbol,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #accessing }
WideSymbol class >> findInterned: aString [
	| symbol string |
	string := aString reduced.
	string == aString ifFalse: [^super findInterned: string].
	symbol := aString bytes changeClassTo: self.
	^SymbolTable lookup: symbol
]

{ #category : #accessing }
WideSymbol class >> intern: aString [
	| symbol canonical |
	aString isAnsiCompliant ifTrue: [^Symbol intern: aString reduced].
	symbol := aString bytes changeClassTo: self.
	canonical := SymbolTable lookup: symbol.
	canonical == nil ifTrue: [^SymbolTable add: symbol].
	^canonical
]

{ #category : #comparing }
WideSymbol >> <= aString [
	^UTF16 current isString: self lessThanOrEqualTo: aString
]

{ #category : #converting }
WideSymbol >> asAnsi [
	^self asString asAnsi asSymbol
]

{ #category : #converting }
WideSymbol >> asLowercase [
	^UTF16 current lowercaseOf: self
]

{ #category : #converting }
WideSymbol >> asSelector [
	^self isAnsiCompliant
		ifTrue: [self asString asAnsi asSelector]
		ifFalse: [self]
]

{ #category : #converting }
WideSymbol >> asString [
	| n string |
	n := self size.
	string := WideString new: n.
	^string replaceFrom: 1 to: n with: self
]

{ #category : #converting }
WideSymbol >> asUppercase [
	^UTF16 current uppercaseOf: self
]

{ #category : #converting }
WideSymbol >> asWideSymbol [
	^self
]

{ #category : #accessing }
WideSymbol >> at: index [
	| cp |
	cp := self checkIndex: index; codeAt: index.
	^Character value: cp
]

{ #category : #accessing }
WideSymbol >> at: index putCode: codePoint [
	^self
		checkIndex: index;
		uLongAtOffset: index - 1 * 4 put: codePoint
]

{ #category : #accessing }
WideSymbol >> atValid: index [
	| cp |
	cp := self codeAt: index.
	^Character value: cp
]

WideSymbol >> basicSize [
	^self _size
]

{ #category : #private }
WideSymbol >> codeAt: index [
	^self uLongAtOffset: index - 1 * 4
]

{ #category : #testing }
WideSymbol >> isUnicode [
	^true
]

{ #category : #testing }
WideSymbol >> isUnicodeSymbol [
	^true
]

{ #category : #accessing }
WideSymbol >> size [
	^self _size // 4
]

{ #category : #accessing }
WideSymbol >> sizeInBytes [
	^self size * 4
]

{ #category : #private }
WideSymbol >> species [
	^WideString
]

{ #category : #private }
WideSymbol >> td1 [
	| m td1 |
	m := self size.
	td1 := Dictionary new: m.
	m to: 1 by: -1 do: [:i | | code |
		code := self uLongAtOffset: i - 1 * 4.
		td1 at: code + 1 ifAbsentPut: [m - i + 1]].
	^td1
]

