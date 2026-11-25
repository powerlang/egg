'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SMethod category: 'Powerlang-Core-SExpressions'!
SScript subclass: #SMethod
	instanceVariableNames: 'pragma'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SMethod methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^visitor visitMethod: self
! !

!SMethod methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMethod
	^true
! !

!SMethod methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
offsetOfCurrentEnvironment
	^ 0
! !

!SMethod methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
offsetOfEnvironment: anInteger
	^0
! !

!SMethod methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pragma
	^pragma
! !

!SMethod methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pragma: anSPragma
	pragma := anSPragma
! !

!SMethod methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitive
	^pragma ifNotNil: [ pragma name ]
! !

!SMethod methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	aStream nextPutAll: '{MethodId. '; cr.
	pragma ifNotNil: [ (pragma isKindOf: SExpression) ifTrue: [ pragma printOn: aStream indent: anInteger + 1] ifFalse: [ aStream tab: anInteger + 1; print: pragma ] ].
	super printOn: aStream indent: anInteger.
	aStream nextPutAll: '}'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMethod class' category: 'Powerlang-Core-SExpressions'!
SMethod class
	instanceVariableNames: ''!


