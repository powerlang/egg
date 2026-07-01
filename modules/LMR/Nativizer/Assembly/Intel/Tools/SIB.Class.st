'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SIB category: #'Powerlang-Core-Assembly-Intel-Tools'!
OctalStructure subclass: #SIB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!SIB commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
base
	^self lo
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
base: anInteger
	self lo: anInteger
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
baseRegister: aRegister
	self base: aRegister index
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^self mid
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index: anInteger
	self mid: anInteger
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
indexRegister: aRegister
	self index: aRegister index
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scale
	^self hi
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scale: anInteger
	self hi: anInteger
! !

!SIB methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scaleFactor: s
	| index |
	index := #[1 2 4 8] indexOf: s.
	self scale: index - 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SIB class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
SIB class
	instanceVariableNames: ''!


