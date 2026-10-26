'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SAssociationBinding category: 'Powerlang-Core-SExpressions'!
SBinding subclass: #SAssociationBinding
	instanceVariableNames: 'index association'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SAssociationBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: value within: anEvaluationContext
	anEvaluationContext storeAssociation: association value: value
! !

!SAssociationBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
association
	^association
! !

!SAssociationBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
association: anAssociation
	association := anAssociation
! !

!SAssociationBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
	^ index
! !

!SAssociationBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: anInteger
	 index := anInteger 
! !

!SAssociationBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isAssociation
	^true
! !

!SAssociationBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isConstant
	^ false
! !

!SAssociationBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueWithin: anEvaluationContext
	^ anEvaluationContext loadAssociationValue: association
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SAssociationBinding class' category: 'Powerlang-Core-SExpressions'!
SAssociationBinding class
	instanceVariableNames: ''!


