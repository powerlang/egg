'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SOpJump category: 'Powerlang-Core-SExpressions'!
SInlinerOperation subclass: #SOpJump
	instanceVariableNames: 'target'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SOpJump methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitOpJump: self
! !

!SOpJump methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: self class name withArticle; nextPutAll: ' after '; print: target
! !

!SOpJump methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
target
	^target
! !

!SOpJump methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
target: anInteger
	 target := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SOpJump class' category: 'Powerlang-Core-SExpressions'!
SOpJump class
	instanceVariableNames: ''!


