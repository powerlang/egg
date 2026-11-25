'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SNumberNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SLiteralNode subclass: #SNumberNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SNumberNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitNumberNode: self
! !

!SNumberNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isNumberNode
	^true
! !

!SNumberNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
negate
	value := value negated
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SNumberNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SNumberNode class
	instanceVariableNames: ''!


