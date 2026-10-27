"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	An ARM64 (AArch64) general-purpose register. Index follows the standard
	encoding: x0..x30 = 0..30, sp/zr = 31 (context-dependent).
	`length` is the operand bitwidth (32 for w*, 64 for x*).
"
Class {
	#name : #ARM64Register,
	#superclass : #Object,
	#instVars : [
		'name',
		'index',
		'length'
	],
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64Register class >> name: aString index: anInteger length: bits [
	^self new name: aString; index: anInteger; length: bits; yourself
]

{ #category : #accessing }
ARM64Register class >> registers [
	| registers |
	registers := Dictionary new.
	0 to: 30 do: [:i |
		self
			add: 'x' , i printString index: i length: 64 to: registers;
			add: 'w' , i printString index: i length: 32 to: registers].
	self
		add: 'sp' index: 31 length: 64 to: registers;
		add: 'wsp' index: 31 length: 32 to: registers;
		add: 'xzr' index: 31 length: 64 to: registers;
		add: 'wzr' index: 31 length: 32 to: registers.
	0 to: 31 do: [:i |
		self
			add: 's' , i printString index: i length: 32 to: registers;
			add: 'd' , i printString index: i length: 64 to: registers;
			add: 'v' , i printString index: i length: 128 to: registers].
	^registers
]

{ #category : #private }
ARM64Register class >> add: name index: anInteger length: bits to: aDictionary [
	| register |
	register := self name: name index: anInteger length: bits.
	aDictionary at: name asSymbol put: register
]

{ #category : #testing }
ARM64Register >> isGeneral [
	^(name first = $x or: [name first = $w]) or: [name = 'sp' or: [name = 'wsp']]
]

{ #category : #testing }
ARM64Register >> isFloat [
	^self isGeneral not
]

{ #category : #testing }
ARM64Register >> isSP [
	^name = 'sp' or: [name = 'wsp']
]

{ #category : #testing }
ARM64Register >> isZero [
	^name = 'xzr' or: [name = 'wzr']
]

{ #category : #accessing }
ARM64Register >> index [
	^index
]

{ #category : #accessing }
ARM64Register >> index: anInteger [
	index := anInteger
]

{ #category : #accessing }
ARM64Register >> length [
	^length
]

{ #category : #accessing }
ARM64Register >> length: bits [
	length := bits
]

{ #category : #accessing }
ARM64Register >> name [
	^name
]

{ #category : #accessing }
ARM64Register >> name: aString [
	name := aString
]

{ #category : #printing }
ARM64Register >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #accessing }
ARM64Register >> byte [
	^self
]

{ #category : #accessing }
ARM64Register >> word [
	^self
]

{ #category : #accessing }
ARM64Register >> e [
	^self
]

{ #category : #accessing }
ARM64Register >> r [
	^self
]


