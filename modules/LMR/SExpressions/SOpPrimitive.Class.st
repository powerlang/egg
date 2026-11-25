'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpPrimitive category: 'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpPrimitive
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpPrimitive methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpPrimitive: self
! !

!SOpPrimitive methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
block
	^block
! !

!SOpPrimitive methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
block: aBlockClosure
	block := aBlockClosure
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpPrimitive class' category: 'Powerlang-Core-SExpressions'!
SOpPrimitive class
	instanceVariableNames: ''!


