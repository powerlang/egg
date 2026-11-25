'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAModRMReader category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAInstructionPartReader subclass: #ISAModRMReader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!ISAModRMReader commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAModRMReader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
contents
	^contents
! !

!ISAModRMReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: aStream
	contents := aStream atEnd ifFalse: [ModRM new on: aStream next]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAModRMReader class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAModRMReader class
	instanceVariableNames: ''!


