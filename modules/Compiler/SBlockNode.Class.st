'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SBlockNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SScriptNode subclass: #SBlockNode
	instanceVariableNames: 'inlined index parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SBlockNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitBlock: self
! !

!SBlockNode methodsFor:  'emitting - inlined' stamp: 'KenD 28/Jun/2026 13:27:40'!
beInlined
	inlined := true.
	arguments do: [:arg | arg binding beInlined]
! !

!SBlockNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildBlock
	| block |
	self isInlined ifTrue: [ ^ nil ].
	block := CompiledBlock new.
	^ block
		blockNumber: index;
		argumentCount: arguments size;
		tempCount: scope stackSize;
		environmentCount: scope environmentSize;
		capturesSelf: scope capturesSelf;
		capturesHome: scope capturesHome
! !

!SBlockNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureHome
	scope captureEnvironment: self ast
! !

!SBlockNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentIndexOf: aParseNode
	^scope environmentIndexOf: aParseNode
! !

!SBlockNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^index
! !

!SBlockNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index: aNumber
	index := aNumber
! !

!SBlockNode methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	inlined := false.
	scope := BlockScope on: self
! !

!SBlockNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isBlockNode
	^true
! !

!SBlockNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isEvaluable
	^self isNullary
! !

!SBlockNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isInlined
	^inlined
! !

!SBlockNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isNullary
	^arguments isEmpty
! !

!SBlockNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
parent
	^parent
! !

!SBlockNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
parent: aScriptNode
	parent := aScriptNode addChild: self
! !

!SBlockNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
realParent
	^parent realScript
! !

!SBlockNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
realScript
	^inlined ifTrue: [parent realScript] ifFalse: [self]
! !

!SBlockNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
usesHome
	^inlined
		ifTrue: [children anySatisfy: [:block | block usesHome]]
		ifFalse: [scope capturesHome]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SBlockNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SBlockNode class
	instanceVariableNames: ''!


SBlockNode initialize!

