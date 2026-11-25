'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpJumpTrue category: 'Powerlang-Core-SExpressions'!
SOpJump subclass: #SOpJumpTrue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpJumpTrue methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpJumpTrue: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpJumpTrue class' category: 'Powerlang-Core-SExpressions'!
SOpJumpTrue class
	instanceVariableNames: ''!


