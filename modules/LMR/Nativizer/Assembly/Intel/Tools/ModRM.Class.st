'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ModRM category: #'Powerlang-Core-Assembly-Intel-Tools'!
OctalStructure subclass: #ModRM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!ModRM commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ModRM methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
beRR
	self mod: 2r11
! !

!ModRM methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	byte := 0
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mod
	^self hi
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mod: anInteger
	self hi: anInteger
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
opcode
	^self reg
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
opcode: anInteger
	self reg: anInteger
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
reg
	^self mid
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
reg: aRegister
	| mid |
	mid := aRegister isInteger
		ifTrue: [aRegister]
		ifFalse: [aRegister index \\ 8].
	self mid: mid
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
rm
	^self lo
! !

!ModRM methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
rm: anInteger
	self lo: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ModRM class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
ModRM class
	instanceVariableNames: ''!

!ModRM class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
new
	"return an initialized instance"

	^ self basicNew initialize.

! !


ModRM initialize!

