'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OBlockClosure category: #IR!
OInstruction subclass: #OBlockClosure
	instanceVariableNames: 'firstBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OBlockClosure commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OBlockClosure methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock
	^firstBlock
! !

!OBlockClosure methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: basicBlock
	firstBlock := basicBlock
! !

!OBlockClosure methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastBlock
	^firstBlock lastBlock
! !

!OBlockClosure methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastValue
	^firstBlock lastBlock lastValue
! !

!OBlockClosure methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OBlockClosure class' category: #IR!
OBlockClosure class
	instanceVariableNames: ''!

!OBlockClosure class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
containing: initialBlock
	^self new firstBlock: initialBlock
! !


