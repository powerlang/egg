'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #InstructionEncoder category: #'Powerlang-Core-Assembler-Intel'!
Object subclass: #InstructionEncoder
	instanceVariableNames: 'instruction spec stream prefixes rex vex opcode modrm sib displacement immediate immediate2 wordSize'
	classVariableNames: 'Cache'
	poolDictionaries: 'Registers'
	category: 'Powerlang-Core-Assembler-Intel'!
!InstructionEncoder commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
arity
	^spec arity
! !

!InstructionEncoder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
at: position
	| pos |
	pos := stream position.
	^[stream position: position; peek] ensure: [stream position: pos]
! !

!InstructionEncoder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
bestMatchingSpec
	| template s |
	template := instruction template.
	s := Cache at: template ifAbsent: nil.
	s notNil ifTrue: [^s].
	s := InstructionSpec
		bestMatchForMnemonic: template mnemonic
		operands: template operands
		wordSize: wordSize.
	Cache at: template copy put: s.
	^s
! !

!InstructionEncoder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacementOffset
	^displacement
! !

!InstructionEncoder methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasDisplacement
	^instruction hasDisplacement
! !

!InstructionEncoder methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasModRM
	^spec hasModRM
! !

!InstructionEncoder methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasRex
	^vex > rex
! !

!InstructionEncoder methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasSib
	^instruction hasSib
! !

!InstructionEncoder methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasVex
	^opcode > vex
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
immediate2: aByteArray
	stream position: immediate2; nextPutAll: aByteArray
! !

!InstructionEncoder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
immediate2Offset
	^immediate2
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
immediate: aByteArray
	immediate isNil ifTrue: [
		immediate := stream position.
		modrm isNil ifTrue: [modrm := sib := displacement := immediate]].
	stream position: immediate.
	aByteArray isCollection
		ifTrue: [stream nextPutAll: aByteArray]
		ifFalse: [stream nextPut: aByteArray].
	immediate2 := stream position
! !

!InstructionEncoder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
immediateOffset
	^immediate
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
indexExtension
	^instruction operands maxValue: [:op | op indexExtension]
! !

!InstructionEncoder methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	wordSize := 8
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
instruction: anISAInstruction
	instruction := anISAInstruction.
	instruction useTemplate
! !

!InstructionEncoder methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
legacyMap
	^String streamContents: [:strm | 
		(prefixes to: rex - 1)
			do: [:i | | p |
				p := self at: i.
				strm nextPutAll: p hex]
			separatedBy: [strm space]]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
mmmmm: anInteger
	| pos byte |
	pos := stream position.
	byte := stream position: vex + 1; peek.
	byte := byte bitOr: anInteger.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
opcode: aByteArray
	| pos |
	pos := stream position.
	stream
		position: opcode;
		nextPutAll: aByteArray;
		position: pos
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand1
	^instruction operand1
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand2
	^instruction operand2
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand3
	^instruction operand3
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand4
	^instruction operand4
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands
	^instruction operands
! !

!InstructionEncoder methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
overridesOperandSize
	| operands op |
	operands := instruction operands.
	operands size = 0 ifTrue: [^false].
	op := operands first.
	(op isRegister and: [op isSegment]) ifTrue: [^false].
	op memoryLength = 16 ifTrue: [
		^instruction mnemonic first = $f
			ifTrue: [spec operands first length !!= 16]
			ifFalse: [true]].
	operands with: spec operands do: [:a :f | 
		(a isImmediate not
			and: [a memoryLength !!= f memoryLength]
			and: [a memoryLength !!= f length]
			and: [(a isMemory and: [f name = 'm']) not])
			ifTrue: [^true]].
	^false
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
pp: anInteger
	| pos offset byte |
	pos := stream position.
	offset := stream peek = 16rC5 ifTrue: [2] ifFalse: [1].
	byte := stream position: vex + offset; peek.
	byte := byte bitOr: anInteger.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefixesMap
	| parts |
	parts := {self legacyMap. self rexMap. self vexMap}.
	parts := parts select: #notEmpty.
	^String
		streamContents: [:strm | parts do: [:p | strm nextPutAll: p; space]]
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
reg: aRegister
	| index prev |
	modrm isNil
		ifTrue: [modrm := stream position]
		ifFalse: [prev := stream position].
	stream position: modrm.
	index := aRegister isInteger ifTrue: [aRegister] ifFalse: [aRegister index].
	self
		writeMid: index;
		rexR: index > 7.
	sib := stream position.
	(prev notNil and: [prev > sib]) ifTrue: [stream position: prev]
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
reset
	spec := rex := modrm := sib := displacement := immediate := nil
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
rexB: aBoolean
	| pos byte |
	aBoolean ifFalse: [^self].
	pos := stream position.
	byte := stream position: rex; peek.
	byte := byte bitOr: REXPrefix b.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
rexB: aBoolean opcode: aByteArray
	(rex isNil or: [rex = opcode]) ifTrue: [
		rex := opcode.
		stream position: rex; nextPut: REXPrefix rex value.
		opcode := opcode + 1].
	self rexB: aBoolean; opcode: aByteArray.
	stream position: opcode; skip: aByteArray size
! !

!InstructionEncoder methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
rexMap
	^String streamContents: [:strm | 
		(rex to: vex - 1)
			do: [:i | | p |
				p := self at: i.
				REXPrefix print: p on: strm]
			separatedBy: [strm space]]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
rexR: aBoolean
	| pos byte |
	aBoolean ifFalse: [^self].
	pos := stream position.
	byte := stream position: rex; peek.
	byte := byte bitOr: REXPrefix r value.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
rexX
	self hasSib ifFalse: [^0].
	instruction operands
		select: [:op | op isMemory]
		thenDo: [:op | ^op indexExtension]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
rexX: aBoolean
	| pos byte |
	aBoolean ifFalse: [^self].
	pos := stream position.
	byte := stream position: rex; peek.
	byte := byte bitOr: REXPrefix x.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
rm: anInteger
	modrm isNil ifTrue: [modrm := stream position].
	stream position: modrm.
	self
		writeLo: anInteger;
		rexB: anInteger > 7.
	sib := stream position.
	self writeSib; writeDisplacement
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
spec
	spec notNil ifTrue: [^spec].
	^spec := self bestMatchingSpec
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
vexB: aBoolean
	| pos byte |
	(self at: vex) = 16rC5 ifTrue: [^self].
	aBoolean ifFalse: [^self].
	pos := stream position.
	byte := stream position: vex + 1; peek.
	byte := byte bitOr: VEXPrefix b.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
vexL: aBoolean
	| pos offset byte |
	aBoolean ifFalse: [^self].
	pos := stream position.
	offset := stream peek = 16rC5 ifTrue: [2] ifFalse: [1].
	byte := stream position: vex + offset; peek.
	byte := byte bitOr: VEXPrefix l.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
vexMap
	^String streamContents: [:strm | 
		(vex to: opcode - 1)
			do: [:i | | p |
				p := self at: i.
				VEXPrefix print: p on: strm]
			separatedBy: [strm space]]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
vexR: aBoolean
	| pos byte |
	aBoolean ifFalse: [^self].
	pos := stream position.
	byte := stream position: vex + 1; peek.
	byte := byte bitOr: VEXPrefix r.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
vexW: aBoolean
	| pos byte |
	aBoolean ifFalse: [^self].
	pos := stream position.
	byte := stream position: vex + 2; peek.
	byte := byte bitOr: VEXPrefix w.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
vexX: aBoolean
	| pos byte |
	(self at: vex) = 16rC5 ifTrue: [^self].
	aBoolean ifFalse: [^self].
	pos := stream position.
	byte := stream position: vex + 1; peek.
	byte := byte bitOr: VEXPrefix x.
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
vreg: aRegister
	| index |
	modrm isNil ifTrue: [modrm := stream position].
	stream position: modrm.
	index := aRegister isInteger ifTrue: [aRegister] ifFalse: [aRegister index].
	self
		writeMid: index;
		vexR: index < 8.
	sib := stream position
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
vrm: anInteger
	modrm isNil ifTrue: [modrm := stream position].
	stream position: modrm.
	self
		writeLo: anInteger;
		vexB: anInteger < 8;
		vexX: self rexX = 0.
	sib := stream position.
	self writeSib; writeDisplacement
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
vvvv: anInteger
	| pos offset byte vvvv |
	pos := stream position.
	stream position: vex.
	offset := stream peek = 16rC5 ifTrue: [1] ifFalse: [2].
	byte := stream position: vex + offset; peek.
	vvvv := (anInteger bitInvert bitShift: 3) bitAnd: 2r1111000.
	byte := (byte bitAnd: 2r10000111) bitOr: vvvv.
	byte < 0 ifTrue: [byte := 256 + byte].
	stream nextPut: byte; position: pos
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize
	^wordSize
! !

!InstructionEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize: anInteger
	self ASSERT: (anInteger = 4 or: [anInteger = 8]).
	wordSize := anInteger
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeDisplacement
	self hasDisplacement ifTrue: [
		instruction operands
			select: [:op | op isMemory]
			thenDo: [:op | stream nextPutAll: op displacementBytes]].
	immediate isNil ifTrue: [immediate := stream position]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeEncodingOn: aStream
	stream := aStream.
	prefixes := rex := vex := stream position.
	self writePrefixes; writeOpcode; writeOperands
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeExtension: anInteger
	| pos bit4 |
	pos := stream position.
	stream position: modrm.
	self writeMid: anInteger.
	(self hasRex and: [bit4 := anInteger > 7]) ifTrue: [self rexR: bit4].
	(self hasVex and: [bit4 := anInteger < 8]) ifTrue: [self vexR: bit4].
	sib := stream position.
	stream position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeHi: anInteger
	| bits byte |
	bits := (anInteger bitAnd: 8r3) bitShift: 6.
	byte := stream peek ifNil: 0.
	byte := (byte bitAnd: 8r77) bitOr: bits.
	stream nextPut: byte
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeLegacyPrefix: byte
	stream nextPut: byte.
	rex := vex := stream position
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeLo: anInteger
	| byte modReg rm |
	byte := stream peek ifNil: 0.
	modReg := byte bitAnd: 8r370.
	rm := anInteger bitAnd: 8r7.
	byte := modReg bitOr: rm.
	stream nextPut: byte
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeMid: anInteger
	| bits byte |
	bits := (anInteger bitAnd: 8r7) bitShift: 3.
	byte := stream peek ifNil: 0.
	byte := (byte bitAnd: 8r307) bitOr: bits.
	stream nextPut: byte
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeMod
	| pos |
	pos := stream position.
	stream position: modrm.
	self writeHi: instruction mod.
	stream position: pos
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeOpcode
	stream position: opcode; nextPutAll: spec primaryOpcode.
	modrm := stream position.
	spec extension ifNotNil: [:e | self writeExtension: e]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeOperands
	spec operandEncoding ifNotNil: [:oe | 
		oe encodeOperands: self.
		self hasModRM ifTrue: [self writeMod]]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writePrefixes
	| head p67 p66 |
	self writeSegmentPrefixes.
	instruction prefix notNil ifTrue: [instruction prefix writeOn: self].
	head := self spec prefixes asOrderedCollection.
	p66 := LegacyPrefix operandSizeOverride.
	p67 := LegacyPrefix addressSizeOverride.
	(head anySatisfy: [:p | p = p66 or: [p = p67] or: [p isVex]]) ifFalse: [
		self overridesOperandSize ifTrue: [head addFirst: p66].
		(instruction overridesAddressSize: wordSize) ifTrue: [head addFirst: p67]].
	head do: [:prefix | prefix writeOn: self].
	((head noneSatisfy: [:p | p isRex or: [p isVex]]) and: [
		(instruction operands anySatisfy: [:op | op needsExtraBit]) or: [
			instruction operands
				anySatisfy: [:op | op = spl or: [op = bpl] or: [op = sil] or: [op = dil]]]])
		ifTrue: [REXPrefix rex writeOn: self].
	opcode := stream position
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeRexPrefix: byte
	self ASSERT: wordSize = 8.
	stream nextPut: byte.
	vex := stream position
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeSegmentPrefixes
	instruction operands
		select: [:op | op isMemory andNot: [op segment isNil]]
		thenDo: [:op | | seg |
			seg := op segment.
			seg = cs ifTrue: [self writeLegacyPrefix: 16r2E].
			seg = ss ifTrue: [self writeLegacyPrefix: 16r36].
			seg = ds ifTrue: [self writeLegacyPrefix: 16r3E].
			seg = es ifTrue: [self writeLegacyPrefix: 16r26].
			seg = fs ifTrue: [self writeLegacyPrefix: 16r64].
			seg = gs ifTrue: [self writeLegacyPrefix: 16r65]]
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeSib
	| operand |
	self hasSib ifTrue: [
		operand := instruction operands detect: [:op | op isMemory].
		stream nextPut: operand sib.
		opcode - vex > 0
			ifTrue: [
				self
					vexX: operand indexExtension = 0;
					vexB: operand baseExtension = 0]
			ifFalse: [
				self
					rexX: operand indexExtension > 0;
					rexB: operand baseExtension > 0]].
	displacement := stream position
! !

!InstructionEncoder methodsFor:  'encoding' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeVexPrefix: aByteArray
	vex := stream position.
	stream nextPutAll: aByteArray
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InstructionEncoder class' category: #'Powerlang-Core-Assembler-Intel'!
InstructionEncoder class
	instanceVariableNames: 'Cache'!

!InstructionEncoder class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
checkCache64
	Cache keysAndValuesDo: [:k :v | | s |
		s := InstructionSpec
			bestMatchForMnemonic: k mnemonic
			operands: k operands
			wordSize: 8.
		self ASSERT: s = v]
! !

!InstructionEncoder class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	self initializeCache

! !

!InstructionEncoder class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeCache
	Cache := Dictionary new
! !

!InstructionEncoder class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
invalidateCache
	Cache removeAll
! !

!InstructionEncoder class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
new
	^super new initialize
! !


InstructionEncoder initialize!

