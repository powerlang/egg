'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAOperandType category: #'Powerlang-Core-Assembler-Intel'!
Object subclass: #ISAOperandType
	instanceVariableNames: 'type length memoryLength flags'
	classVariableNames: 'Types'
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!ISAOperandType commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
addFlag: flagBit
	flags := flags bitOr: flagBit
! !

!ISAOperandType methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
constant
	| i |
	i := #('0' '1' '3') indexOf: type.
	^i > 0 ifTrue: [#[0 1 3] at: i]
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
getMemoryLength
	(type includesString: '/m8') ifTrue: [^8].
	(type includesString: '/m16') ifTrue: [^16].
	(type includesString: '/m32') ifTrue: [^32].
	(type includesString: '/m64') ifTrue: [^64].
	(type includesString: '/m128') ifTrue: [^128].
	(type includesString: ':16') ifTrue: [^0].
	(type includesString: ':32') ifTrue: [^0].
	(type includesString: ':64') ifTrue: [^0].
	^length
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasFlag: flagBit
	^flags isOnBit: flagBit
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasImmediateFlag
	^self hasFlag: ImmediateType
! !

!ISAOperandType methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeConstantFlag
	type anyone isDigit ifTrue: [self addFlag: ConstantType]

! !

!ISAOperandType methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeImmediateFlag
	((type includesString: 'imm') or: [type includesString: 'rel'])
		ifTrue: [self addFlag: ImmediateType]
! !

!ISAOperandType methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeMemoryFlag
	self isImmediate ifTrue: [^self].
	(#('m8' 'm16' 'm32' 'm64' 'm128' 'm256' 'm512')
		anySatisfy: [:s | type includesString: s])
		ifTrue: [^self addFlag: MemoryType].
	((type includes: $m)
		and: [(type includesString: 'mm') not]
		and: [(type includesString: 'vm') not]
		and: [(type includesString: 'offs') not])
		ifTrue: [self addFlag: MemoryType]
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeMemoryLength
	memoryLength := self getMemoryLength
! !

!ISAOperandType methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeRegisterFlag
	self isImmediate ifTrue: [^self].
	(type includesString: 'r/m') ifTrue: [^self addFlag: RegisterType].
	(#('r8' 'r16' 'r32' 'r64' 'reg') anySatisfy: [:s | type includesString: s])
		ifTrue: [^self addFlag: RegisterType].
	(type includesString: 'mm') ifTrue: [^self addFlag: RegisterType].
	(self specificRegisterNames includes: type)
		ifTrue: [self addFlag: RegisterType]
! !

!ISAOperandType methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeRegisterGroupFlag
	self isImmediate ifTrue: [^self].
	(type includesString: 'r/m') ifTrue: [^self addFlag: RegisterGP].
	(#('r8' 'r16' 'r32' 'r64' 'reg') anySatisfy: [:s | type includesString: s])
		ifTrue: [^self addFlag: RegisterGP].
	(type includesString: 'mm') ifTrue: [^self addFlag: RegisterSIMD].
	(self specificRegisterNames includes: type)
		ifTrue: [^self addFlag: RegisterSpecific].
	type = 'sreg' ifTrue: [^self addFlag: RegisterSegment]
! !

!ISAOperandType methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeSegmentFlag
	^type = 'sreg' ifTrue: [self addFlag: RegisterSegment]
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isConstant
	^self hasFlag: ConstantType
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isImmediate
	^self hasFlag: ImmediateType
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isMemory
	^self hasFlag: MemoryType
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isMoff
	^type beginsWith: 'moff'
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isRegister
	^self hasFlag: RegisterType
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSegment
	^self hasFlag: RegisterSegment
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSpecificRegister
	^self registerGroup = RegisterSpecific
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
length
	^length
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
length: aString
	length := aString = '?' ifFalse: [aString asInteger]
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
lengthForBits: n
	^(type beginsWith: 'moff') ifTrue: [n] ifFalse: [length]
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memoryLength
	^memoryLength
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^type
! !

!ISAOperandType methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
normalized
	type first = $r ifFalse: [^self].
	type = 'rel8' ifTrue: [^self class imm8].
	type = 'rel16' ifTrue: [^self class imm16].
	type = 'rel32' ifTrue: [^self class imm32].
	type = 'r32a' ifTrue: [^self class r32].
	type = 'r32b' ifTrue: [^self class r32].
	type = 'r64a' ifTrue: [^self class r64].
	type = 'r64b' ifTrue: [^self class r64]
! !

!ISAOperandType methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
operandFrom: anInteger
	self ASSERT: self isMoff.
	^MemoryOperand new displacement: anInteger; length: memoryLength
! !

!ISAOperandType methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	aStream nextPutAll: type
! !

!ISAOperandType methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
register
	type = '<xmm0>' ifTrue: [^xmm0].
	type = 'r8' ifTrue: [^nil].
	^Register named: type
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
registerGroup
	^flags bitAnd: RegisterGroupMask
! !

!ISAOperandType methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
specificRegisterNames
	^#('rax' 'eax' 'ax' 'al' 'cl' 'dx' 'es' 'cs' 'ss' 'ds' 'fs' 'gs')
! !

!ISAOperandType methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
type: aString
	type := aString.
	flags := 0.
	self
		initializeMemoryLength;
		initializeConstantFlag;
		initializeImmediateFlag;
		initializeMemoryFlag;
		initializeRegisterFlag;
		initializeSegmentFlag;
		initializeRegisterGroupFlag
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAOperandType class' category: #'Powerlang-Core-Assembler-Intel'!
ISAOperandType class
	instanceVariableNames: 'Types'!

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
imm16
	^self named: 'imm16'
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
imm32
	^self named: 'imm32'
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
imm8
	^self named: 'imm8'
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
immediateTypes
	^Types select: [:t | t isImmediate]
! !

!ISAOperandType class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeOperandTypeFlags
	self addNamespaceAs: #OperandTypeFlags.
	OperandTypeFlags
		at: #MemoryType put: 4;
		at: #RegisterGroupMask put: 3840;
		at: #ConstantType put: 2;
		at: #RegisterSIMD put: 256;
		at: #ImmediateType put: 1;
		at: #RegisterGP put: 0;
		at: #RegisterType put: 8;
		at: #RegisterSegment put: 512;
		at: #RegisterSpecific put: 768.
! !

!ISAOperandType class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeTypes
	| dictionary |
	dictionary := Dictionary new.
	self typeNames lines collect: [:s | | pair type |
		pair := s substrings.
		type := self new type: pair first; length: pair second.
		dictionary at: type name put: type].
	Types := dictionary
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
memoryTypes
	^Types select: [:t | t isMemory] in: OrderedCollection new
! !

!ISAOperandType class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
named: aString
	^Types at: aString
! !

!ISAOperandType class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
operandTypeFlags
	^OperandTypeFlags
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
r32
	^self named: 'r32'
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
r64
	^self named: 'r64'
! !

!ISAOperandType class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
typeNames
	^'<xmm0> 128
		0 8
		1 8
		3 0
		al 8
		dx 16
		ax 16
		cl 8
		cr0-cr7 ?
		cr8 ?
		cs 16
		dr0-dr7 ?
		ds 16
		dx 16
		eax 32
		dx 16
		es 16
		far 0
		fs 16
		gs 16
		imm16 16
		imm32 32
		imm64 64
		imm8 8
		m ?
		m108byte ?
		m128 128
		m16 16
		m16&16 16
		m16&32 ?
		m16&64 ?
		m16:16 16
		m16:32 48
		m16:64 80
		m16int 16
		m256 256
		m28byte 7
		m2byte 16
		m32 32
		m32&32 32
		m32fp 32
		m32int 32
		m512byte 512
		m64 64
		m64fp 64
		m64int 64
		m8 8
		m80bcd 80
		m80fp 80
		mem ?
		mm 64
		mm1 64
		mm2 64
		mm/m32 64
		mm/m64 64
		mm2/m64 64
		moffs16 16
		moffs32 32
		moffs64 64
		moffs8 8
		p66 0
		ptr16:16 16
		ptr16:32 16
		pw 0
		r/m16 16
		r/m32 32
		r/m64 64
		r/m8 8
		r/m8 8
		r8 8
		r16 16
		r16/m16 16
		r32 32
		r32/m16 32
		r32/m32 32
		r32/m8 32
		r32a 32
		r32b 32
		r64 64
		r64/m16 64
		r64/m64 64
		r64a 64
		r64b 64
		rax 64
		reg ?
		reg/m16 16
		reg/m32 32
		reg/m8 8
		rel16 16
		rel32 32
		rel8 8
		sreg 16
		ss 16
		st ?
		st(0) ?
		st(i) ?
		vm32x 32
		vm32y 32
		vm64x 64
		vm64y 64
		xmm 128
		xmm/m128 128
		xmm/m32 128
		xmm/m64 128
		xmm0 128
		xmm1 128
		xmm1/m128 128
		xmm1/m32 128
		xmm1/m64 128
		xmm2 128
		xmm2/m128 128
		xmm2/m16 128
		xmm2/m32 128
		xmm2/m64 128
		xmm2/m8 128
		xmm3 128
		xmm3/m128 128
		xmm3/m32 128
		xmm3/m64 128
		xmm4 128
		ymm0 256
		ymm1 256
		ymm2 256
		ymm2/m256 256
		ymm3/m256 256
		ymm4 256'
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
typeOfSpecialRegister: aRegister
	aRegister = rax ifTrue: [^self named: 'rax'].
	aRegister = eax ifTrue: [^self named: 'eax'].
	aRegister = ax ifTrue: [^self named: 'ax'].
	aRegister = al ifTrue: [^self named: 'al'].
	aRegister = cl ifTrue: [^self named: 'cl'].
	aRegister = dx ifTrue: [^self named: 'dx']
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
typesOfGeneralRegister: aRegister
	| bits associations |
	bits := aRegister length asString.
	associations := OrderedCollection new: 4.
	Types do: [:type | | n |
		n := type name.
		n = ('r' , bits) ifTrue: [associations add: 1 -> type].
		n = 'reg' ifTrue: [associations add: 2 -> type].
		n = ('r/m' , bits) ifTrue: [associations add: 3 -> type].
		n = ('r' , bits , '/m' , bits) ifTrue: [associations add: 4 -> type]].
	^(associations sortBy: #key) collect: #value
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
typesOfSIMDRegister: aRegister
	| s |
	s := aRegister name.
	^Types select: [:type | | n |
		(#('0' '1' '3') includes: type name) not
			and: [
				n := type name upTo: $/.
				n size >= 3]
			and: [n first !!= $m]
			and: [s includesString: n]]
! !

!ISAOperandType class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
typesOfSegmentRegister: aRegister
	| type sreg |
	type := self named: aRegister name.
	sreg := self named: 'sreg'.
	^{type. sreg}
! !


