'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpStoreRintoFrame category: 'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpStoreRintoFrame
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpStoreRintoFrame methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpStoreRintoFrame: self
! !

!SOpStoreRintoFrame methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
	^ index
! !

!SOpStoreRintoFrame methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: anInteger
	index := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpStoreRintoFrame class' category: 'Powerlang-Core-SExpressions'!
SOpStoreRintoFrame class
	instanceVariableNames: ''!


