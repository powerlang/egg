'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SDynamicBinding category: 'Powerlang-Core-SExpressions'!
SBinding subclass: #SDynamicBinding
	instanceVariableNames: 'name cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: value within: anEvaluationContext ifUnbound: aClosure

	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	cache ifNil: [ ^ aClosure value ].
	cache assign: value within: anEvaluationContext
! !

!SDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isDynamic
	^true
! !

!SDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupWithin: anEvaluationContext
	cache := anEvaluationContext staticBindingFor: name
! !

!SDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	name
! !

!SDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: aSymbol
	name := aSymbol
! !

!SDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: 'DinamicVarId. ';
		nextPutAll: name printString
! !

!SDynamicBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext ifUnbound: aClosure

	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	cache ifNil: [ ^ aClosure value ].
	^ cache valueWithin: anEvaluationContext
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SDynamicBinding class' category: 'Powerlang-Core-SExpressions'!
SDynamicBinding class
	instanceVariableNames: ''!

!SDynamicBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^ aTreecodeDecoder decodeDynamicVar
! !


