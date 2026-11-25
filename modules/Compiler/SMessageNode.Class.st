'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SMessageNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SMessageNode
	instanceVariableNames: 'selector receiver arguments inlined'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SMessageNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitMessage: self
! !

!SMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
arguments
	^arguments
! !

!SMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
arguments: aCollection
	arguments := aCollection
! !

!SMessageNode methodsFor:  'emitting - inlined' stamp: 'KenD 28/Jun/2026 13:27:40'!
beInlined
	inlined := true
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasAssign
	receiver hasAssign ifTrue: [^true].
	^arguments anySatisfy: [:arg | arg hasAssign]
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasVolatileArguments
	^arguments anySatisfy: [:arg | 
		arg isIdentifier
			ifTrue: [arg binding canBeAssigned]
			ifFalse: [arg isBlockNode not andNot: [arg isLiteral]]]
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasVolatileReceiver
	^ compiler hasBlocks
		  or: [ receiver isMethodTemporary not ]
		  or: [ arguments anySatisfy: [ :arg | arg hasAssign ] ]
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	inlined := false
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCascadeMessage
	^false
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isInlined
	^inlined
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isMessageNode
	^true
! !

!SMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
needsStrictEvaluationOrder
	arguments size = 0 ifTrue: [^false].
	receiver isBlockNode ifTrue: [^false].
	receiver isLiteral ifTrue: [^false].
	receiver isSelf ifTrue: [^false].
	receiver isSuper ifTrue: [^false].
	receiver isMethodArgument ifTrue: [^false].
	self hasVolatileReceiver ifFalse: [^false].
	(receiver isImmediate
		and: [arguments conform: [:arg | arg isImmediate or: [arg isBlockNode]]])
		ifTrue: [^false].
	receiver hasAssign ifTrue: [^true].
	receiver isMessageNode ifTrue: [ ^true ]. 
	^self hasVolatileArguments
! !

!SMessageNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:40'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	receiver nodesDo: aBlock includingDeclarations: aBoolean.
	arguments do: [:arg | arg nodesDo: aBlock includingDeclarations: aBoolean].
	selector nodesDo: aBlock includingDeclarations: aBoolean
! !

!SMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
receiver
	^receiver
! !

!SMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
receiver: node
	receiver := node
! !

!SMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
selector
	^selector
! !

!SMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
selector: node
	selector := node
! !

!SMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
symbol
	^selector symbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMessageNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SMessageNode class
	instanceVariableNames: ''!


SMessageNode initialize!

