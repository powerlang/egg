'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STemporaryBinding category: 'Powerlang-Core-SExpressions'!
SLocalBinding subclass: #STemporaryBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!STemporaryBinding methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: value within: anEvaluationContext
	anEvaluationContext temporaryAt: position in: environment put: value
! !

!STemporaryBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInCurrentEnvironment
	^environment = 1
! !

!STemporaryBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isTemporary
	^true
! !

!STemporaryBinding methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: 'STemporary ';
		print: position;
		nextPutAll: ' @ env ';
		print: environment
! !

!STemporaryBinding methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext temporaryAt: position in: environment
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STemporaryBinding class' category: 'Powerlang-Core-SExpressions'!
STemporaryBinding class
	instanceVariableNames: ''!

!STemporaryBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeTemporary
! !


