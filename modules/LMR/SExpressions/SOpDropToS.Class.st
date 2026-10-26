'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpDropToS category: 'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpDropToS
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpDropToS methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpDropToS: self
! !

!SOpDropToS methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
count
	^count
! !

!SOpDropToS methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
count: anInteger
	count := anInteger 
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpDropToS class' category: 'Powerlang-Core-SExpressions'!
SOpDropToS class
	instanceVariableNames: ''!


