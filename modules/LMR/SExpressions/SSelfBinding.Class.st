'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SSelfBinding category: 'Powerlang-Core-SExpressions'!
SBinding subclass: #SSelfBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SSelfBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSelf
	^true
! !

!SSelfBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: 'SelfId'
! !

!SSelfBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext receiver
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSelfBinding class' category: 'Powerlang-Core-SExpressions'!
SSelfBinding class
	instanceVariableNames: ''!

!SSelfBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^self new
! !


