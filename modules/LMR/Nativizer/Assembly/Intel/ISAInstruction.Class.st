'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAInstruction category: #'Powerlang-Core-Assembler-Intel'!
Object subclass: #ISAInstruction
	instanceVariableNames: 'prefix mnemonic operands template'
	classVariableNames: ''
	poolDictionaries: 'Registers'
	category: 'Powerlang-Core-Assembler-Intel'!
!ISAInstruction commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAInstruction methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
= instruction
	self class == instruction class ifFalse: [^false].
	prefix = instruction prefix ifFalse: [^false].
	mnemonic = instruction mnemonic ifFalse: [^false].
	(self hasOperands or: [instruction hasOperands]) ifFalse: [^true].
	operands isNil ifTrue: [^false].
	operands size = instruction arity ifFalse: [^false].
	operands
		with: instruction operands
		do: [:op1 :op2 | op1 = op2 ifFalse: [^false]].
	^true
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
arity
	^operands size
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beTemplate
	1 to: operands size do: [:i | | op |
		op := operands at: i.
		operands at: i put: op template]
! !

!ISAInstruction methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
db: byte
	| imm |
	mnemonic := '.db'.
	imm := ISAImmediate new value: byte.
	operands := {imm}
! !

!ISAInstruction methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
encoder
	^InstructionEncoder new instruction: self
! !

!ISAInstruction methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
encoding32
	| s |

	s := ReadWriteStream on: ByteArray new.
	self writeEncoding32On: s.
	^ s contents.

! !

!ISAInstruction methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
encoding64
	| s |

	s := ReadWriteStream on: ByteArray new.
	self writeEncoding64On: s.
	^ s contents.

! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasDirectMemoryReference
	^operands anySatisfy: [:op | op isDirectMemoryReference]
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasDisplacement
	operands isNil ifTrue: [^false].
	^operands anySatisfy: [:op | op isMemory and: [op hasDisplacement]]
! !

!ISAInstruction methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasOperands
	^operands notNil and: [operands size > 0]
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasSib
	operands isNil ifTrue: [^false].
	^operands anySatisfy: [:op | op isMemory and: [op hasSib]]
! !

!ISAInstruction methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hash
	^prefix hashWith: mnemonic with: self operand1 with: self operand2
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCall
	^mnemonic = 'call'
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isJump
	^mnemonic first = $j or: [mnemonic beginsWith: 'loop']
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLike: anISAInstruction
	self class = anISAInstruction class ifFalse: [^false].
	mnemonic = anISAInstruction mnemonic ifTrue: [^self = anISAInstruction].
	operands = anISAInstruction operands ifFalse: [^false].
	^self spec isLike: anISAInstruction spec
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isPushFP
	| operand |
	^(mnemonic beginsWith: 'push')
		and: [
			operand := operands at: 1.
			operand isRegister]
		and: [operand index = rbp index]
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isReturn
	^mnemonic = 'ret'
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isTemplate
	1
		to: operands size
		do: [:i | (operands at: i) isTemplate ifFalse: [^false]].
	^true
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isTestAL1
	mnemonic = 'test' ifFalse: [^false].
	operands first = al ifFalse: [^false].
	operands second isImmediate ifFalse: [^false].
	^operands second value = 1
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpOffset32
	self ASSERT:
		((self isJump or: [ self isCall ]) and: [ 
			 operands anyone isImmediate ]).
	^ operands first value + self sizeInBytes32
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpOffset64
	self ASSERT:
		((self isJump or: [ self isCall ]) and: [ 
			 operands anyone isImmediate ]).
	^ operands first value + self sizeInBytes64
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mnemonic
	^mnemonic
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mnemonic: aString
	mnemonic := aString asLowercase.
	template notNil ifTrue: [template mnemonic: aString]
! !

!ISAInstruction methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
mod
	(operands conform: [:op | op isRegister or: [op isImmediate]])
		ifTrue: [^2r11].
	operands do: [:op | op isMemory ifTrue: [^op mod]]
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand1
	^operands notNil ifTrue: [operands at: 1 ifAbsent: nil]
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand2
	^operands notNil ifTrue: [operands at: 2 ifAbsent: nil]
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand3
	^operands at: 3
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand4
	^operands at: 4
! !

!ISAInstruction methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
operandFrom: anObject
	anObject isInteger ifTrue: [^ISAImmediate new value: anObject].
	anObject isString ifTrue: [
		^anObject first = $@
			ifTrue: [anObject]
			ifFalse: [MemoryOperand fromString: anObject]].
	^anObject
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands
	^operands ifNil: #()
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands: aCollection
	operands := aCollection collect: [:op | self operandFrom: op].
	template notNil
		ifTrue: [template operands: (operands collect: [:op | op template])]
! !

!ISAInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
overridesAddressSize: anInteger
	| length |
	operands isNil ifTrue: [^false].
	length := anInteger bitShift: 3.
	^operands
		anySatisfy: [:op | op isMemory
			and: [op base notNil]
			and: [op pointerLength !!= length]]
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefix
	^prefix
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefix: aLegacyPrefix
	prefix := aLegacyPrefix.
	template notNil ifTrue: [template prefix: aLegacyPrefix]
! !

!ISAInstruction methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	aStream nextPutAll: mnemonic.
	operands isNil ifTrue: [^self].
	operands
		do: [:op | aStream space; nextPutAll: op asString]
		separatedBy: [aStream nextPut: $,]
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sizeInBytes32
	| stream |
	stream := #[  ] writeStream.
	self writeEncoding32On: stream.
	^ stream size
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sizeInBytes64
	| stream |
	stream := #[  ] writeStream.
	self writeEncoding64On: stream.
	^ stream size
! !

!ISAInstruction methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
spec
	^self encoder spec
! !

!ISAInstruction methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
template
	^template
! !

!ISAInstruction methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:40'!
updateTemplate: anISAInstruction
	| arity array |
	arity := operands size.
	array := Array new: arity.
	1 to: arity do: [:i | array at: i put: (operands at: i) template].
	anISAInstruction
		prefix: prefix;
		mnemonic: mnemonic;
		operands: array
! !

!ISAInstruction methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
useTemplate
	template := self shallowCopy.
	mnemonic isNil ifTrue: [^self].
	template mnemonic: mnemonic; prefix: prefix.
	operands notNil
		ifTrue: [template operands: (operands collect: [:op | op template])]
! !

!ISAInstruction methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeEncoding32On: aStream
	^self encoder wordSize: 4; writeEncodingOn: aStream
! !

!ISAInstruction methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeEncoding64On: aStream
	^self encoder wordSize: 8; writeEncodingOn: aStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAInstruction class' category: #'Powerlang-Core-Assembler-Intel'!
ISAInstruction class
	instanceVariableNames: ''!

!ISAInstruction class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
db: byte
	^self new db: byte
! !


