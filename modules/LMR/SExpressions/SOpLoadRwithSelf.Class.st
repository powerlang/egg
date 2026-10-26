'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpLoadRwithSelf category: 'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpLoadRwithSelf
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpLoadRwithSelf methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpLoadRwithSelf: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpLoadRwithSelf class' category: 'Powerlang-Core-SExpressions'!
SOpLoadRwithSelf class
	instanceVariableNames: ''!


