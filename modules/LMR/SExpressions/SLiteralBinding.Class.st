'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SLiteralBinding category: 'Powerlang-Core-SExpressions'!
SBinding subclass: #SLiteralBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SLiteralBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLiteral
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SLiteralBinding class' category: 'Powerlang-Core-SExpressions'!
SLiteralBinding class
	instanceVariableNames: ''!

!SLiteralBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^self new
! !


