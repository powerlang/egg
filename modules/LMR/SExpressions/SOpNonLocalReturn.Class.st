'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpNonLocalReturn category: 'Powerlang-Core-SExpressions'!
SOpReturn subclass: #SOpNonLocalReturn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpNonLocalReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpNonLocalReturn: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpNonLocalReturn class' category: 'Powerlang-Core-SExpressions'!
SOpNonLocalReturn class
	instanceVariableNames: ''!


