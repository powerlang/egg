'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpJumpFalse category: 'Powerlang-Core-SExpressions'!
SOpJump subclass: #SOpJumpFalse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpJumpFalse methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpJumpFalse: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpJumpFalse class' category: 'Powerlang-Core-SExpressions'!
SOpJumpFalse class
	instanceVariableNames: ''!


