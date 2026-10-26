'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ElfSectionHeaderTable category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #ElfSectionHeaderTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	"This method was automatically generated"
	^handle unsignedLongAt: 9
! !

!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
! !

!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
number
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
number: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !

!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shndx
	"This method was automatically generated"
	^handle unsignedLongAt: 13
! !

!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shndx: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
! !

!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!ElfSectionHeaderTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElfSectionHeaderTable class' category: 'SqueakNOS-External-Structures'!
ElfSectionHeaderTable class
	instanceVariableNames: ''!

!ElfSectionHeaderTable class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	^#(
		(number 'ulong')
		(size 'ulong')
		(address 'ulong')
		(shndx 'ulong')
	   )
! !


