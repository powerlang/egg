'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #AssemblerParser category: #'Powerlang-Core-Assembly-Intel-Parser'!
AssemblerGrammar subclass: #AssemblerParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Parser'!
!AssemblerParser commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
bitLengthOf: anInteger
	(anInteger between: -16r80 and: 16r7F) ifTrue: [^8].
	(anInteger between: -16r8000 and: 16r7FFF) ifTrue: [^16].
	(anInteger between: -16r80000000 and: 16r7FFFFFFF) ifTrue: [^32].
	(anInteger between: -16r8000000000000000 and: 16r7FFFFFFFFFFFFFFF)
		ifTrue: [^64].
	(anInteger
		between: -16r80000000000000000000000000000000
		and: 16r7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
		ifTrue: [^128].
	^nil
! !

!AssemblerParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
comma
	^super comma ==> [:nodes | ]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
decimal
	^super decimal ==> [:node | node asInteger]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacement
	^super displacement
		==> [:nodes | nodes first = $-
			ifTrue: [nodes second negated]
			ifFalse: [nodes second]]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hex
	^super hex
		==> [:nodes | Integer readFrom: nodes second readStream radix: 16]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
immD
	^super immD ==> [:nodes | | sign value |
		sign := nodes first = $- ifTrue: [-1] ifFalse: [1].
		value := nodes second * sign.
		ISAImmediate new value: value]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
immH
	^super immH ==> [:value | | s len |
		len := self bitLengthOf: value.
		s := self signInteger: value.
		s < 0 ifTrue: [len := len // 2].
		ISAImmediate new value: s; length: len]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^super index ==> [:nodes | nodes second]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
instruction
	^super instruction ==> [:nodes | 
		ISAInstruction new
			prefix: nodes first;
			mnemonic: nodes second;
			operands: (nodes third ifNil: #())]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memory
	^super memory ==> [:nodes | | memory |
		memory := nodes fourth.
		nodes third ifNotNil: [:seg | memory segment: seg first].
		nodes first ifNotNil: [:len | memory length: len].
		memory]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memorySize
	^super memorySize ==> [:nodes | | c index |
		index := 'bwdqxyz' indexOf: nodes first first.
		#(8 16 32 64 128 256 512) at: index]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands
	^super operands ==> [:nodes | | reg |
		nodes notNil ifTrue: [
			reg := nodes
				detect: [:op | op isInteger not
					and: [op isString not]
					and: [op isRegister]]
				ifNone: nil.
			reg notNil ifTrue: [
				nodes
					select: [:op | op isInteger not
						and: [op isMemory]
						and: [op length isNil]]
					thenDo: [:op | op length: reg length]]].
		nodes]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands1
	^super operands1 ==> [:node | {node}]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands2
	^super operands2 ==> [:nodes | {nodes first. nodes third}]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands3
	^super operands3 ==> [:nodes | {nodes first. nodes third. nodes fifth}]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
parseInstruction: aString
	| array |
	array := self parse: aString.
	^array anyOne

! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefix
	^super prefix ==> [:name | InstructionPrefix prefixes at: name asUppercase]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
reg
	^super reg ==> [:nodes | Register named: nodes]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scale
	^super scale ==> [:nodes | nodes second digitValue]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
segment
	^super segment ==> [:nodes | Register named: nodes]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib1
	^super sib1 ==> [:node | MemoryOperand new displacement: node]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib2
	| scale displacement |
	^ super sib2
		==> [ :nodes |  scale := nodes third ifNil: [ 1 ].
			displacement := nodes fourth ifNil: [ 0 ].
			MemoryOperand new
				base: nodes first;
				index: nodes second;
				scale: scale;
				displacement: displacement ]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib3
	^super sib3 ==> [:nodes | 
		MemoryOperand new
			index: nodes first;
			scale: nodes second;
			displacement: nodes third]
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
signInteger: anInteger
	anInteger < 0 ifTrue: [^anInteger].
	anInteger < 16r80 ifTrue: [^anInteger].
	anInteger < 16r100 ifTrue: [^anInteger - 16r100].
	anInteger < 16r8000 ifTrue: [^anInteger].
	anInteger < 16r10000 ifTrue: [^anInteger - 16r10000].
	anInteger < 16r80000000 ifTrue: [^anInteger].
	anInteger < 16r100000000 ifTrue: [^anInteger - 16r100000000].
	anInteger < 16r8000000000000000 ifTrue: [^anInteger].
	anInteger < 16r10000000000000000
		ifTrue: [^anInteger - 16r10000000000000000].
	^anInteger
! !

!AssemblerParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
start
	^super start ==> [:nodes | | tail |
		tail := nodes second collect: [:a | a second].
		Array with: nodes first withAll: tail]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AssemblerParser class' category: #'Powerlang-Core-Assembly-Intel-Parser'!
AssemblerParser class
	instanceVariableNames: ''!


