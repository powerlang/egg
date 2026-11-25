'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STrueBinding category: 'Powerlang-Core-SExpressions'!
SLiteralBinding subclass: #STrueBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!STrueBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: 'TrueId'
! !

!STrueBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
value
	^true
! !

!STrueBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STrueBinding class' category: 'Powerlang-Core-SExpressions'!
STrueBinding class
	instanceVariableNames: ''!


