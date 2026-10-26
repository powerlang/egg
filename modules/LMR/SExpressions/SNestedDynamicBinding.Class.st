'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SNestedDynamicBinding category: 'Powerlang-Core-SExpressions'!
SDynamicBinding subclass: #SNestedDynamicBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SNestedDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupWithin: anEvaluationContext
	cache := anEvaluationContext staticBindingForNested: name
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SNestedDynamicBinding class' category: 'Powerlang-Core-SExpressions'!
SNestedDynamicBinding class
	instanceVariableNames: ''!

!SNestedDynamicBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^ aTreecodeDecoder decodeNestedDynamicVar
! !


