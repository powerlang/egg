'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SFalseBinding category: 'Powerlang-Core-SExpressions'!
SLiteralBinding subclass: #SFalseBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SFalseBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: 'FalseId'
! !

!SFalseBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
value
	^false
! !

!SFalseBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SFalseBinding class' category: 'Powerlang-Core-SExpressions'!
SFalseBinding class
	instanceVariableNames: ''!


