'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #DisplayInformation category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #DisplayInformation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	"This method was automatically generated"
	^handle unsignedLongAt: 13
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesPerScanLine
	"This method was automatically generated"
	^handle unsignedLongAt: 17
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesPerScanLine: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 17 put: anObject
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
depth
	"This method was automatically generated"
	^handle unsignedLongAt: 9
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
depth: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
height
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
height: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
width
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!DisplayInformation methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
width: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DisplayInformation class' category: 'SqueakNOS-External-Structures'!
DisplayInformation class
	instanceVariableNames: ''!

!DisplayInformation class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	^#(
		(width 'ulong')
		(height 'ulong')
		(depth 'ulong')
		(address 'ulong')
		(bytesPerScanLine 'ulong')
	    )
! !


