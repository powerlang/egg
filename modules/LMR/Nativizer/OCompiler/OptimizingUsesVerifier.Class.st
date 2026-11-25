'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingUsesVerifier category: #OCompiler!
Object subclass: #OptimizingUsesVerifier
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingUsesVerifier commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
verify: definition usedBy: user
	definition isInteger ifTrue: [^self].
	definition usesDo: [:use | use instruction == user ifTrue: [^self]].
	self error: 'Corrupted instruction usage'
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
verifyFrom: firstBlock
	firstBlock
		instructionsWithSuccessorsDo: [:instruction | instruction
			acceptVisitor: self]
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithConstant: instruction
	self verify: instruction left usedBy: instruction
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithVariable: instruction
	self
		verify: instruction left usedBy: instruction;
		verify: instruction right usedBy: instruction
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: instruction
	
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: instruction
	self verify: instruction variable usedBy: instruction
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: instruction
	self verify: instruction variable usedBy: instruction
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: instruction
	
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadImplicit: instruction
	
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: instruction
	self verify: instruction receiver usedBy: instruction
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitNullary: instruction
	
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: instruction
	instruction variables
		do: [:operation | self verify: operation usedBy: instruction]
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: instruction
	self verify: instruction source usedBy: instruction
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitTernary: instruction
	self
		verify: instruction receiver usedBy: instruction;
		verify: instruction left usedBy: instruction;
		verify: instruction right usedBy: instruction
! !

!OptimizingUsesVerifier methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	self verify: instruction receiver usedBy: instruction
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingUsesVerifier class' category: #OCompiler!
OptimizingUsesVerifier class
	instanceVariableNames: ''!


