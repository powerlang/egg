'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SBinding category: 'Powerlang-Core-SExpressions'!
Object subclass: #SBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: value within: anEggRuntime
	^ self subclassResponsibility
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: value within: anEvaluationContext ifUnbound: aClosure
	^self assign: value within: anEvaluationContext

! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isArgument
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isAssociation
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isClassBinding
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isClassVar
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isDynamic
	^ false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInstVar
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLiteral
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPoolVar
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSelf
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSuper
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isTemporary
	^false
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^self printString
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ self subclassResponsibility
! !

!SBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext ifUnbound: aClosure
	^self valueWithin: anEvaluationContext
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SBinding class' category: 'Powerlang-Core-SExpressions'!
SBinding class
	instanceVariableNames: ''!

!SBinding class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^self subclassResponsibility
! !


