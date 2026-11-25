'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #RISCCodeGenerator category: #'Powerlang-Core-Assembly'!
CodeGenerator subclass: #RISCCodeGenerator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearHigh32: srcAndDstReg
	self
		shiftLeft: srcAndDstReg byImm: 32;
		shiftRight: srcAndDstReg byImm: 32
! !

!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
dec: srcAndDstReg
	self addImm: -1 to: srcAndDstReg

! !

!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
decMem: aMemRef
	self addImm: -1 toMem: aMemRef

! !

!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
inc: srcAndDstReg
	self addImm: 1 to: srcAndDstReg

! !

!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
pop: srcReg
	| memref |
	memref := self memRef base: self regSP.
	self
		load: srcReg fromMem: memref;
		addImm: wordSize to: self regSP 
! !

!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
push: srcReg
	| memref |
	memref := self memRef base: self regSP; displacement: -8.
	self
		store: srcReg intoMem: memref;
		subImm: wordSize from: self regSP 
! !

!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushImm: imm
	| memref |
	memref := self memRef base: self regSP; displacement: -8.
	self moveImm: imm to: self regV;
		store: self regV intoMem: memref;
		subImm: wordSize from: self regSP 
! !

!RISCCodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
subImm: anInteger from: srcAndDstReg
	self addImm: anInteger negated to: srcAndDstReg

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RISCCodeGenerator class' category: #'Powerlang-Core-Assembly'!
RISCCodeGenerator class
	instanceVariableNames: ''!


