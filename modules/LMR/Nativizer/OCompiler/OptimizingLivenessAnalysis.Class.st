'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingLivenessAnalysis category: #OCompiler!
Object subclass: #OptimizingLivenessAnalysis
	instanceVariableNames: 'firstBlock liveIn liveOut loops pressures expirations'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingLivenessAnalysis commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
analyzeLiveness
	| changed all |
	liveIn := Dictionary new.
	pressures := Dictionary new.
	expirations := Dictionary new.
	changed := true.
	all := firstBlock withSuccessorsPostOrder.
	[changed] whileTrue: [
		changed := false.
		all do: [:block | changed := (self analyzeLivenessOf: block) or: changed]].
	all do: [:block | self computeExpirationsAt: block]
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
analyzeLivenessOf: block
	| alive last changed pressure |
	self haltWhen: block hash = 46528.
	alive := self gatherAliveAfter: block.
	self
		haltWhen: (alive
			anySatisfy: [:value | value printString
				beginsWith: '[53422] [jump to #45650]']).
	pressure := pressures at: block ifAbsentPut: [0].
	last := block lastInstruction.
	last realReverseDo: [:instr | | presure |
		instr operandsDo: [:value | 
			self haltWhen: (value printString beginsWith: '[53422] [jump to #45650]').
			alive addIfAbsent: value].
		alive removeIfPresent: instr.
		pressure := presure max: alive size].
	block phis reverseDo: [:phi | alive removeIfPresent: phi].
	pressures at: block put: pressure.
	changed := true.
	liveIn
		at: block ifPresent: [:prev | changed := prev size !!= alive size];
		at: block put: alive.
	^changed
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeExpirationsAt: block
	| alive last |
	alive := self gatherAliveAfter: block.
	last := block lastInstruction.
	last isConditionalJump ifTrue: [
		block successors do: [:succ | | real leftover |
			real := liveIn at: succ.
			leftover := alive rejectAll: real.
			leftover do: [:val | self kill: val at: succ firstInstruction]]].
	last realReverseDo: [:instr | self computeExpirationsAt: instr with: alive]
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeExpirationsAt: instruction with: alive
	instruction operandsDo: [:value | 
		(alive includes: value) ifFalse: [self kill: value at: instruction].
		alive addIfAbsent: value].
	(alive includes: instruction)
		ifTrue: [alive remove: instruction]
		ifFalse: [self kill: instruction at: instruction]
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
does: operand dieAt: instruction
	| dying |
	dying := expirations at: instruction ifAbsent: [^false].
	^dying includes: operand
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: aBlock
	firstBlock := aBlock
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
gatherAliveAfter: block
	| incoming extra |
	incoming := block successors
		gather: [:succ | liveIn at: succ ifAbsent: [OrderedCollection new]].
	extra := block successors gather: [:succ | succ phiValuesComingFrom: block].
	^(incoming , extra) withoutDuplicates
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
kill: value at: instruction
	| collection |
	collection := expirations
		at: instruction
		ifAbsentPut: [OrderedCollection new].
	collection addIfAbsent: value
! !

!OptimizingLivenessAnalysis methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
liveInOf: block
	^liveIn at: block
! !

!OptimizingLivenessAnalysis methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
loops: aDictionary
	loops := aDictionary
! !

!OptimizingLivenessAnalysis methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
maxPressureIn: loopBlocks
	| all |
	all := loopBlocks collect: [:block | pressures at: block].
	^all max
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingLivenessAnalysis class' category: #OCompiler!
OptimizingLivenessAnalysis class
	instanceVariableNames: ''!

!OptimizingLivenessAnalysis class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingLivenessAnalysis initialize!

