'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #KernelModule category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #KernelModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
end
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
end: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reserved
	"This method was automatically generated"
	^handle unsignedLongAt: 13
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reserved: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
start
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
start: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
string
	"This method was automatically generated"
	^handle unsignedLongAt: 9
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
string: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'KernelModule class' category: 'SqueakNOS-External-Structures'!
KernelModule class
	instanceVariableNames: ''!

!KernelModule class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	^#(
		(start 'ulong')
		(end 'ulong')
		(string 'ulong')
		(reserved 'ulong')
	   )
! !


