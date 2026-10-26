'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpAssign category: 'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpAssign
	instanceVariableNames: 'assignees'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpAssign methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpAssign: self
! !

!SOpAssign methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assignees
	^assignees
! !

!SOpAssign methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assignees: aCollection
	assignees := aCollection
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpAssign class' category: 'Powerlang-Core-SExpressions'!
SOpAssign class
	instanceVariableNames: ''!


