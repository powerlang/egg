'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SArgumentBinding category: 'Powerlang-Core-SExpressions'!
SLocalBinding subclass: #SArgumentBinding
	instanceVariableNames: 'inlined'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: value within: anEvaluationContext
	self halt
! !

!SArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isArgument
	^true
! !

!SArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInlined
	^ environment = -1
! !

!SArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: 'SArgument ';
		print: position;
		nextPutAll: ' @ env ';
		print: environment
! !

!SArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext argumentAt: position in: environment
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SArgumentBinding class' category: 'Powerlang-Core-SExpressions'!
SArgumentBinding class
	instanceVariableNames: ''!

!SArgumentBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeArgument
! !


