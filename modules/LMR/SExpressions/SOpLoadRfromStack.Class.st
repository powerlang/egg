'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpLoadRfromStack category: 'Powerlang-Core-SExpressions'!
SOperation subclass: #SOpLoadRfromStack
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpLoadRfromStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpLoadRfromStack: self
! !

!SOpLoadRfromStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
	^index
! !

!SOpLoadRfromStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: anInteger
	index := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpLoadRfromStack class' category: 'Powerlang-Core-SExpressions'!
SOpLoadRfromStack class
	instanceVariableNames: ''!


