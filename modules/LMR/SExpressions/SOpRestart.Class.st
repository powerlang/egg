'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpRestart category: 'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpRestart
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpRestart methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpRestart: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpRestart class' category: 'Powerlang-Core-SExpressions'!
SOpRestart class
	instanceVariableNames: ''!


