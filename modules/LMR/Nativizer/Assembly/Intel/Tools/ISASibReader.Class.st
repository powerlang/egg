'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISASibReader category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAInstructionPartReader subclass: #ISASibReader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!ISASibReader commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISASibReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
contents
	^contents
! !

!ISASibReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: aStream
	contents := SIB new on: aStream next
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISASibReader class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISASibReader class
	instanceVariableNames: ''!


