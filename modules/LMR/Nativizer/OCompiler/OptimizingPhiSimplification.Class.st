'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingPhiSimplification category: #OCompiler!
Object subclass: #OptimizingPhiSimplification
	instanceVariableNames: 'marks'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingPhiSimplification commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingPhiSimplification methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	marks := Set new
! !

!OptimizingPhiSimplification methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMarked: instruction
	^marks includes: instruction
! !

!OptimizingPhiSimplification methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
mark: instruction
	^marks add: instruction
! !

!OptimizingPhiSimplification methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
process: aBasicBlock
	| instruction |
	instruction := aBasicBlock firstInstruction.
	[instruction isPhi] whileTrue: [| vars next |
		next := instruction next.
		vars := instruction variables.
		vars size to: 1 by: -1 do: [:i | | var |
			var := vars at: i.
			(self isMarked: var) ifFalse: [instruction removeVariable: var]].
		instruction := next]
! !

!OptimizingPhiSimplification methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
processFrom: firstBlock
	firstBlock instructionsWithSuccessorsDo: [:inst | self mark: inst].
	firstBlock reversePostOrderDo: [:block | self process: block]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingPhiSimplification class' category: #OCompiler!
OptimizingPhiSimplification class
	instanceVariableNames: ''!

!OptimizingPhiSimplification class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingPhiSimplification initialize!

