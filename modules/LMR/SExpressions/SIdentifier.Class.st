'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SIdentifier category: 'Powerlang-Core-SExpressions'!
SExpression subclass: #SIdentifier
	instanceVariableNames: 'binding'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^visitor visitIdentifier: self
! !

!SIdentifier methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
binding
	^binding
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
binding: aBinding
	binding := aBinding
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isArgument
	^binding isArgument
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isAssociation
	^binding isAssociation
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isIdentifier
	^true
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInstVar
	^binding isInstVar
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLiteral
	^binding isLiteral
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSelf
	^binding isSelf
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSelfOrSuper
	^binding isSelf or: [binding isSuper]
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSuper
	^binding isSuper
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isTemporary
	^binding isTemporary
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isVariable
	^true
! !

!SIdentifier methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	aStream
		tab: anInteger;
		nextPutAll: '{IdentifierId. ';
		print: binding;
		nextPutAll: '}'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SIdentifier class' category: 'Powerlang-Core-SExpressions'!
SIdentifier class
	instanceVariableNames: ''!

!SIdentifier class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeIdentifier
! !


