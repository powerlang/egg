'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SNilBinding category: 'Powerlang-Core-SExpressions'!
SLiteralBinding subclass: #SNilBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SNilBinding methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: 'NilId'
! !

!SNilBinding methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:39'!
value
	^nil
! !

!SNilBinding methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SNilBinding class' category: 'Powerlang-Core-SExpressions'!
SNilBinding class
	instanceVariableNames: ''!


