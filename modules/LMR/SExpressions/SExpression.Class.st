'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SExpression category: 'Powerlang-Core-SExpressions'!
Object subclass: #SExpression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SExpression commentStamp: '<historical>' prior: 0!

I am a Smalltalk expression, the minimal unit of Smalltalk semantics, expressed as a tree
!

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^self subclassResponsibility
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isAssignment
	^false
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isCascade
	^false
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isCascadeMessage
	^false
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isIdentifier
	^false
! !

!SExpression methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInstVar
	^false
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLiteral
	^false
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMessage
	^false
! !

!SExpression methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMethod
	^false
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isReturn
	^false
! !

!SExpression methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSuper
	^ false
! !

!SExpression methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	self printOn: aStream indent: 0
! !

!SExpression methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	super printOn: aStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SExpression class' category: 'Powerlang-Core-SExpressions'!
SExpression class
	instanceVariableNames: ''!


