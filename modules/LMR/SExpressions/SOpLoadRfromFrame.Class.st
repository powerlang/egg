'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpLoadRfromFrame category: 'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpLoadRfromFrame
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpLoadRfromFrame methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpLoadRfromFrame: self
! !

!SOpLoadRfromFrame methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
^	index
! !

!SOpLoadRfromFrame methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: anInteger
	index := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpLoadRfromFrame class' category: 'Powerlang-Core-SExpressions'!
SOpLoadRfromFrame class
	instanceVariableNames: ''!


