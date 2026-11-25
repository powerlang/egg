'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OTiling category: #IR!
Object subclass: #OTiling
	instanceVariableNames: 'action cost used instruction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OTiling commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OTiling methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
beUsed
	used := true
! !

!OTiling methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	used := false
! !

!OTiling methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instruction
	^instruction
! !

!OTiling methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instruction: anInstruction
	instruction := anInstruction
! !

!OTiling methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUsed
	^used = true
! !

!OTiling methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: self printString
! !

!OTiling methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printString
	^'<tiling of ' , instruction printString , ' >'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OTiling class' category: #IR!
OTiling class
	instanceVariableNames: ''!

!OTiling class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
for: instruction
	^self new instruction: instruction
! !

!OTiling class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OTiling initialize!

