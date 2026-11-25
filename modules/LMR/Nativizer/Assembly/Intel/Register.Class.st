'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #Register category: #'Powerlang-Core-Assembler-Intel'!
ISAOperand subclass: #Register
	instanceVariableNames: 'name index family flags'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!Register commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!Register methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
addFlag: flagBit
	flags := flags bitOr: flagBit
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
b
	^family at: 1
! !

!Register methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
byte
	^self b
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
e
	^family at: 3
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
extensionBit
	^self isExtended ifTrue: [1] ifFalse: [0]
! !

!Register methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
family: anArray
	family := anArray
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
forLength: reglength
	self ASSERT: (#(8 16 32 64) includes: reglength).

	reglength ==  8 ifTrue: [ ^ self b ].
	reglength == 16 ifTrue: [ ^ self w ].
	reglength == 32 ifTrue: [ ^ self e ].
	reglength == 64 ifTrue: [ ^ self r ].

! !

!Register methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
getB
	self == rax ifTrue: [^al].
	self == rcx ifTrue: [^cl].
	self == rdx ifTrue: [^dl].
	self == rbx ifTrue: [^bl].
	self == rsi ifTrue: [^sil].
	self == rdi ifTrue: [^dil].
	self == rbp ifTrue: [^bpl].
	self == rsp ifTrue: [^spl].
	self == r8 ifTrue: [^r8b].
	self == r9 ifTrue: [^r9b].
	self == r10 ifTrue: [^r10b].
	self == r11 ifTrue: [^r11b].
	self == r12 ifTrue: [^r12b].
	self == r13 ifTrue: [^r13b].
	self == r14 ifTrue: [^r14b].
	self == r15 ifTrue: [^r15b].
	^nil
! !

!Register methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
getE
	self == rax ifTrue: [^eax].
	self == rcx ifTrue: [^ecx].
	self == rdx ifTrue: [^edx].
	self == rbx ifTrue: [^ebx].
	self == rsi ifTrue: [^esi].
	self == rdi ifTrue: [^edi].
	self == rbp ifTrue: [^ebp].
	self == rsp ifTrue: [^esp].
	self == r8 ifTrue: [^r8d].
	self == r9 ifTrue: [^r9d].
	self == r10 ifTrue: [^r10d].
	self == r11 ifTrue: [^r11d].
	self == r12 ifTrue: [^r12d].
	self == r13 ifTrue: [^r13d].
	self == r14 ifTrue: [^r14d].
	self == r15 ifTrue: [^r15d].
	^nil
! !

!Register methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
getW
	self == rax ifTrue: [^ax].
	self == rcx ifTrue: [^cx].
	self == rdx ifTrue: [^dx].
	self == rbx ifTrue: [^bx].
	self == rsi ifTrue: [^si].
	self == rdi ifTrue: [^di].
	self == rbp ifTrue: [^bp].
	self == rsp ifTrue: [^sp].
	self == r8 ifTrue: [^r8w].
	self == r9 ifTrue: [^r9w].
	self == r10 ifTrue: [^r10w].
	self == r11 ifTrue: [^r11w].
	self == r12 ifTrue: [^r12w].
	self == r13 ifTrue: [^r13w].
	self == r14 ifTrue: [^r14w].
	self == r15 ifTrue: [^r15w].
	^nil
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^index
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index: anInteger
	index := anInteger
! !

!Register methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeFamily
	(name first = $r and: [length = 64]) ifTrue: [
		family := {self getB. self getW. self getE. self}.
		family select: #notNil thenDo: [:reg | reg family: family]]
! !

!Register methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeFlags
	flags := 0.
	self initializeRegisterGroupFlag
! !

!Register methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeRegisterGroupFlag
	(name includesString: 'mm') ifTrue: [^self addFlag: RegisterSIMD].
	(#('es' 'cs' 'ss' 'ds' 'fs' 'gs') includes: name)
		ifTrue: [^self addFlag: RegisterSegment].
	self addFlag: RegisterGP
! !

!Register methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCompatibleWith: anOperandType
	anOperandType isRegister ifFalse: [^false].
	(anOperandType registerGroup = self registerGroup
		and: [length = anOperandType length or: [anOperandType length isNil]])
		ifTrue: [^true].
	^anOperandType isSpecificRegister and: [name = anOperandType name]
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isExtended
	^index > 7
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isGeneral
	^self registerGroup = RegisterGP
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLongModeOld8BitRegister
	self = spl ifTrue: [^true].
	self = bpl ifTrue: [^true].
	self = sil ifTrue: [^true].
	self = dil ifTrue: [^true].
	^false
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isRegister
	^true
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSIMD
	^self registerGroup = RegisterSIMD
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSegment
	^self registerGroup = RegisterSegment
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isTemplate
	^true
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
long
	^ family at: 3
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^name
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name: aString
	name := aString asLowercase
! !

!Register methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
needsExtraBit
	^self isExtended
! !

!Register methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefers: anOperandType to: anotherOperandType
	^anOperandType name = name
! !

!Register methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	name isNil ifTrue: [^super printOn: aStream].
	aStream nextPutAll: name
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
r
	^family at: 4
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regExtension
	^self extensionBit
! !

!Register methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
registerGroup
	^flags bitAnd: RegisterGroupMask
! !

!Register methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
rm
	^index
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
short
	^ family at: 2
! !

!Register methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
w
	^family at: 2
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Register class' category: #'Powerlang-Core-Assembler-Intel'!
Register class
	instanceVariableNames: ''!

!Register class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
addRegister: aRegister
	Registers at: aRegister name asSymbol put: aRegister
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize16BitRegisters
	#('ax' 'cx' 'dx' 'bx' 'sp' 'bp' 'si' 'di' 'r8w' 'r9w' 'r10w' 'r11w' 'r12w' 'r13w' 'r14w' 'r15w')
		withIndexDo: [:r :i | | register |
			register := self new
				name: r;
				index: i - 1;
				length: 16;
				initializeFlags.
			self addRegister: register]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize32BitRegisters
	#('eax' 'ecx' 'edx' 'ebx' 'esp' 'ebp' 'esi' 'edi' 'r8d' 'r9d' 'r10d' 'r11d' 'r12d' 'r13d' 'r14d' 'r15d')
		withIndexDo: [:r :i | | register |
			register := self new
				name: r;
				index: i - 1;
				length: 32;
				initializeFlags.
			self addRegister: register]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize64BitRegisters
	#('rax' 'rcx' 'rdx' 'rbx' 'rsp' 'rbp' 'rsi' 'rdi' 'r8' 'r9' 'r10' 'r11' 'r12' 'r13' 'r14' 'r15')
		withIndexDo: [:r :i | | register |
			register := self new
				name: r;
				index: i - 1;
				length: 64;
				initializeFlags.
			self addRegister: register]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize8BitRegisters
	#('al' 'cl' 'dl' 'bl' 'ah' 'ch' 'dh' 'bh') withIndexDo: [:r :i | | register |
		register := Register new
			name: r;
			index: i - 1;
			length: 8;
			initializeFlags.
		self addRegister: register]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize8BitRexRegisters
	#('spl' 'bpl' 'sil' 'dil' 'r8b' 'r9b' 'r10b' 'r11b' 'r12b' 'r13b' 'r14b' 'r15b')
		withIndexDo: [:r :i | | register |
			register := self new
				name: r;
				index: i + 3;
				length: 8;
				initializeFlags.
			self addRegister: register]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeFamilies
	Registers do: [:reg | reg initializeFamily]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeMMXRegisters
	0 to: 7 do: [:i | | mmx |
		mmx := self new
			name: 'mmx' , i asString;
			index: i;
			length: 64;
			initializeFlags.
		self addRegister: mmx]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeRIPRegister
	| register |
	register := self new
		name: 'rip';
		index: 5;
		length: 64;
		initializeFlags.
	self addRegister: register
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeRegisters
	
	self
		addNamespaceAs: #Registers;
		initialize8BitRegisters;
		initialize8BitRexRegisters;
		initialize16BitRegisters;
		initialize32BitRegisters;
		initialize64BitRegisters;
		initializeRIPRegister;
		initializeMMXRegisters;
		initializeSSERegisters;
		initializeSegmentRegisters
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeSSERegisters
	0 to: 15 do: [:i | | xmm |
		xmm := self new
			name: 'xmm' , i asString;
			index: i;
			length: 128;
			initializeFlags.
		self addRegister: xmm].
	0 to: 15 do: [:i | | ymm |
		ymm := self new
			name: 'ymm' , i asString;
			index: i;
			length: 256;
			initializeFlags.
		self addRegister: ymm]
! !

!Register class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeSegmentRegisters
	#('es' 'cs' 'ss' 'ds' 'fs' 'gs') withIndexDo: [:r :i | | register |
		register := self new
			name: r;
			index: i - 1;
			length: 16;
			initializeFlags.
		self addRegister: register]
! !

!Register class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
named: aString
	"
	Register named: 'rax'
	"
	^Registers at: aString asLowercase ifAbsent: nil
! !

!Register class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
registers
	^Registers
! !

!Register class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
segment: index
	index = 0 ifTrue: [^cs].
	index = 1 ifTrue: [^ss].
	index = 2 ifTrue: [^ds].
	index = 3 ifTrue: [^es].
	index = 4 ifTrue: [^fs].
	index = 5 ifTrue: [^gs].
	^nil
! !

!Register class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
withIndex: index length: length
	^Registers detect: [:r | 
		r index = index
			and: [r length = length]
			and: [(r name beginsWith: 'mmx') not]
			and: [r isSegment not]]
! !

!Register class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
withIndex: index length: length long: aBoolean
	^Registers detect: [:r | 
		r index = index
			and: [r length = length]
			and: [(r name beginsWith: 'mmx') not]
			and: [r isSegment not]
			and: [r isLongModeOld8BitRegister ifTrue: [aBoolean] ifFalse: [true]]]
! !

!Register class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
xmm: i
	^self named: 'xmm' , i asString
! !

!Register class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
ymm: i
	^self named: 'ymm' , i asString
! !


