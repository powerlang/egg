'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpPopR category: 'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpPopR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpPopR methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpPopR: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpPopR class' category: 'Powerlang-Core-SExpressions'!
SOpPopR class
	instanceVariableNames: ''!


