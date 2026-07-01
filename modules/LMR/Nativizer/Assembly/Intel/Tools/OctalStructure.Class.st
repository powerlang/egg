'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #OctalStructure category: #'Powerlang-Core-Assembly-Intel-Tools'!
Object subclass: #OctalStructure
	instanceVariableNames: 'byte'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!OctalStructure commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!OctalStructure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hi
	^byte bitShift: -6
! !

!OctalStructure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hi: anInteger
	| bits |
	self ASSERT: anInteger < 4.
	bits := anInteger bitShift: 6.
	byte := (byte bitAnd: 2r111111) bitOr: bits
! !

!OctalStructure methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
lo
	^byte bitAnd: 7
! !

!OctalStructure methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
lo: anInteger
	self ASSERT: anInteger < 8.
	byte := (byte bitAnd: 2r11111000) bitOr: anInteger
! !

!OctalStructure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mid
	^(byte bitShift: -3) bitAnd: 7
! !

!OctalStructure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mid: anInteger
	| bits |
	self ASSERT: anInteger < 8.
	bits := anInteger bitShift: 3.
	byte := (byte bitAnd: 2r11000111) bitOr: bits
! !

!OctalStructure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
on: anInteger
	byte := anInteger
! !

!OctalStructure methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	| hi mid lo |
	hi := self hi printPaddedWith: $0 to: 2 base: 2.
	mid := self mid printPaddedWith: $0 to: 3 base: 2.
	lo := self lo printPaddedWith: $0 to: 3 base: 2.
	aStream
		nextPutAll: hi;
		nextPut: $.;
		nextPutAll: mid;
		nextPut: $.;
		nextPutAll: lo
! !

!OctalStructure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^byte
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OctalStructure class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
OctalStructure class
	instanceVariableNames: ''!

!OctalStructure class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
new
	^super new initialize
! !


