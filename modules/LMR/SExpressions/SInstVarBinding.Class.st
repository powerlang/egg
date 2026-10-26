'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SInstVarBinding category: 'Powerlang-Core-SExpressions'!
SBinding subclass: #SInstVarBinding
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SInstVarBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: value within: anEvaluationContext
	anEvaluationContext instanceVarAt: index put: value
! !

!SInstVarBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
	^index
! !

!SInstVarBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: anInteger
	index := anInteger
! !

!SInstVarBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInstVar
	^true
! !

!SInstVarBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: 'InstVarId. '; nextPutAll: index printString
! !

!SInstVarBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext instanceVarAt: index
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SInstVarBinding class' category: 'Powerlang-Core-SExpressions'!
SInstVarBinding class
	instanceVariableNames: ''!

!SInstVarBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeInstVar
! !


