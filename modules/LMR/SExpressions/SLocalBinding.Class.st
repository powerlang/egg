'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SLocalBinding category: 'Powerlang-Core-SExpressions'!
SBinding subclass: #SLocalBinding
	instanceVariableNames: 'position environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SLocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
environment
	^environment
! !

!SLocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
environment: anInteger
	environment := anInteger
! !

!SLocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
	^position
! !

!SLocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: anInteger
	position := anInteger
! !

!SLocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInStack
	self ASSERT: false.
	^ environment = 0
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SLocalBinding class' category: 'Powerlang-Core-SExpressions'!
SLocalBinding class
	instanceVariableNames: ''!


