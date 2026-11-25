'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #MultiBootMemoryMapEntry category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #MultiBootMemoryMapEntry
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
baseAddress
	"This method was automatically generated"
	^handle doubleAt: 5
! !

!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
baseAddress: anObject
	"This method was automatically generated"
	handle doubleAt: 5 put: anObject
! !

!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length
	"This method was automatically generated"
	^handle doubleAt: 13
! !

!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length: anObject
	"This method was automatically generated"
	handle doubleAt: 13 put: anObject
! !

!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !

!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	"This method was automatically generated"
	^handle unsignedLongAt: 21
! !

!MultiBootMemoryMapEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 21 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MultiBootMemoryMapEntry class' category: 'SqueakNOS-External-Structures'!
MultiBootMemoryMapEntry class
	instanceVariableNames: ''!

!MultiBootMemoryMapEntry class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	^#(
		(size 'ulong')
		(baseAddress 'double')
		(length 'double')
		(type 'ulong')
	   )
! !


