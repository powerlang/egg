'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAInstructionPartReader category: #'Powerlang-Core-Assembly-Intel-Tools'!
Object subclass: #ISAInstructionPartReader
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!ISAInstructionPartReader commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAInstructionPartReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
contents
	^contents contents
! !

!ISAInstructionPartReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: aStream
	contents := #[] writeStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAInstructionPartReader class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAInstructionPartReader class
	instanceVariableNames: ''!


