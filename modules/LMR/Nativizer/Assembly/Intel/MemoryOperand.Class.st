'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #MemoryOperand category: #'Powerlang-Core-Assembler-Intel'!
ISAOperand subclass: #MemoryOperand
	instanceVariableNames: 'base index scale displacement segment'
	classVariableNames: ''
	poolDictionaries: 'Registers'
	category: 'Powerlang-Core-Assembler-Intel'!
!MemoryOperand commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!MemoryOperand methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
= operand
	self class == operand class ifFalse: [^false].
	length = operand length ifFalse: [^false].
	base = operand base ifFalse: [^false].
	index = operand index ifFalse: [^false].
	self scale = operand scale ifFalse: [^false].
	displacement = operand displacement ifFalse: [^false].
	^segment = operand segment
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
base
	^base
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
base: aRegister
	base := aRegister
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
baseExtension
	^base notNil ifTrue: [base extensionBit] ifFalse: [0]
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacement
	^displacement

! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacement: anInteger
	self ASSERT: anInteger isInteger.
	self ASSERT: (anInteger between: -2147483648 and: 2147483647).
	displacement := anInteger

! !

!MemoryOperand methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacementBytes
	| bytes displ n |
	n := (base notNil and: [displacement between: -128 and: 127])
		ifTrue: [1]
		ifFalse: [4].
	base == rip ifTrue: [n := 4].
	bytes := ByteArray new: n.
	displ := displacement.
	1 to: bytes size do: [:i | 
		bytes at: i put: (displ bitAnd: 16rFF).
		displ := displ bitShift: -8].
	^bytes
! !

!MemoryOperand methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacementLength
	displacement = 0 ifTrue: [^0].
	^(base notNil and: [displacement between: -128 and: 127])
		ifTrue: [1]
		ifFalse: [4]
! !

!MemoryOperand methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacementValue
	| value |
	displacement isNumber ifTrue: [^displacement].
	displacement size = 4 ifTrue: [^displacement longAtOffset: 0].
	displacement size = 2 ifTrue: [^displacement shortAtOffset: 0].
	value := displacement at: 1.
	(value isOnBit: 16r80) ifTrue: [^value - (1 bitShift: displacement size * 8)].
	^value
! !

!MemoryOperand methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeSib: aSIB
	| s i b |
	s := scale ifNil: 1.
	i := index isNil ifTrue: [rsp index] ifFalse: [index index \\ 8].
	b := base isNil ifTrue: [rbp index] ifFalse: [base index \\ 8].
	aSIB
		scaleFactor: s;
		index: i;
		base: b
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasDisplacement
	^self hasExplicitDisplacement
		or: [base isNil]
		or: [self requiresSpecialCaseDisplacement]
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasExplicitDisplacement
	^displacement !!= 0
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasOnlyDisplacement
	^index isNil and: [base isNil]
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasSib
	^index notNil or: [self requiresSpecialCaseSib]
! !

!MemoryOperand methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hash
	^length
		hashWith: base
		with: index
		with: scale
		with: displacement
		with: segment
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^index
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index: aRegister
	index := aRegister
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
indexExtension
	^index notNil ifTrue: [index extensionBit] ifFalse: [0]
! !

!MemoryOperand methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	displacement := 0.
	scale := 1
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCompatibleWith: anOperandType
	^anOperandType isMemory
		and: [length = anOperandType memoryLength
			or: [anOperandType memoryLength isNil]]
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDirectMemoryReference
	^self hasOnlyDisplacement
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isMemory
	^true
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isTemplate
	^displacement = 0
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
length: anInteger
	self ASSERT: (#(8 16 32 64 128) includes: anInteger).
	length := anInteger

! !

!MemoryOperand methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
lengthString
	length = 256 ifTrue: [^'ymmword ptr'].
	length = 128 ifTrue: [^'xmmword ptr'].
	(length isNil or: [length = 64]) ifTrue: [^'qword ptr'].
	length = 32 ifTrue: [^'dword ptr'].
	length = 16 ifTrue: [^'word ptr'].
	length = 8 ifTrue: [^'byte ptr'].
	self ASSERT: false.
	^''
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memoryLength
	^length
! !

!MemoryOperand methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
mod
	base == rip ifTrue: [^2r0].
	base isNil ifTrue: [^0].
	self hasDisplacement ifFalse: [^0].
	(displacement between: -128 and: 127) ifTrue: [^2r1] ifFalse: [^2r10]
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
needsExtraBit
	(base notNil and: [base needsExtraBit]) ifTrue: [^true].
	^index notNil and: [index needsExtraBit]
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
pointerLength
	base notNil ifTrue: [^base length].
	^self displacementLength
! !

!MemoryOperand methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	| sign displ |
	aStream nextPutAll: self lengthString; nextPutAll: ' ['.
	segment notNil ifTrue: [
		segment printOn: aStream.
		aStream nextPut: $:].
	base notNil ifTrue: [base printOn: aStream].
	index notNil ifTrue: [
		base notNil ifTrue: [aStream nextPutAll: ' + '].
		index printOn: aStream.
		scale isNil
			ifFalse: [aStream nextPutAll: ' * '; nextPutAll: scale asString]].
	displ := self displacementValue.
	displ !!= 0 ifTrue: [
		(base notNil or: [index notNil]) ifTrue: [
			sign := displ > 0 ifTrue: [' + '] ifFalse: [' - '].
			aStream nextPutAll: sign].
		aStream nextPutAll: '0x'; nextPutAll: displ abs hex].
	aStream nextPut: $]
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
requiresSpecialCaseDisplacement
	^base notNil and: [base == r13 or: [base r == rbp]]
! !

!MemoryOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
requiresSpecialCaseSib
	base ifNil: [^true].
	^base == r12 or: [base r == rsp]
! !

!MemoryOperand methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
reset
	base := index := segment := length := nil.
	displacement := 0.
	scale := 1
! !

!MemoryOperand methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
rm
	self hasSib ifTrue: [^2r100].
	^base ifNil: [2r101] ifNotNil: [base index]
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scale
	^scale

! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scale: anInteger
	self ASSERT: (#(1 2 4 8) includes: anInteger).
	scale := anInteger

! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
segment
	^segment
! !

!MemoryOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
segment: aRegister
	segment := aRegister
! !

!MemoryOperand methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib
	| factor s i b |
	factor := scale ifNil: 1.
	s := #[1 2 4 8] indexOf: factor.
	i := index isNil ifTrue: [rsp index] ifFalse: [index index bitAnd: 8r7].
	b := base isNil ifTrue: [rbp index] ifFalse: [base index bitAnd: 8r7].
	^((s - 1 bitShift: 6) bitOr: (i bitShift: 3)) bitOr: b
! !

!MemoryOperand methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
template
	| template bits d |
	template := self copy.
	displacement = 0 ifTrue: [^template].
	bits := self displacementLength.
	d := bits = 1 ifTrue: [16r3F] ifFalse: [16r3FFFFFFF].
	^template displacement: d
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MemoryOperand class' category: #'Powerlang-Core-Assembler-Intel'!
MemoryOperand class
	instanceVariableNames: ''!

!MemoryOperand class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
fromStream: aStream
	| memory |
	memory := AssemblerParser new memory parse: aStream.
	memory isPetitFailure
		ifTrue: [self error: 'invalid operand: ' , memory message].
	^memory
! !

!MemoryOperand class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
fromString: aString
	"
	MemoryOperand fromString: 'qword ptr [rbx]'
	"
	^self fromStream: aString readStream
! !

!MemoryOperand class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !


MemoryOperand initialize!

