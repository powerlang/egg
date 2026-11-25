'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #SymbolTable category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #SymbolTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	"This method was automatically generated"
	^handle unsignedLongAt: 9
! !

!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
! !

!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reserved
	"This method was automatically generated"
	^handle unsignedLongAt: 13
! !

!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reserved: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
! !

!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
strSize
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
strSize: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !

!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
tabSize
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!SymbolTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
tabSize: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SymbolTable class' category: 'SqueakNOS-External-Structures'!
SymbolTable class
	instanceVariableNames: ''!

!SymbolTable class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	^#(
		(tabSize 'ulong')
		(strSize 'ulong')
		(address 'ulong')
		(reserved 'ulong')
	   )
	

! !


