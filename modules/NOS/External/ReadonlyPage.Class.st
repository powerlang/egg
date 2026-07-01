'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ReadonlyPage category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #ReadonlyPage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!ReadonlyPage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents
	"This method was automatically generated"
	^(Buffer at: self address + 8 size: 4096) contents
	
! !

!ReadonlyPage methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	"self defineFields"
	^#(
		(virtual 'ulong')
		(physical 'ulong')
		(contents 'string' 4096)
	   )
! !

!ReadonlyPage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
physical
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!ReadonlyPage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
physical: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !

!ReadonlyPage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
virtual
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!ReadonlyPage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
virtual: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReadonlyPage class' category: 'SqueakNOS-External-Structures'!
ReadonlyPage class
	instanceVariableNames: ''!


