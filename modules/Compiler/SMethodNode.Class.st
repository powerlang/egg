'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #SMethodNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SScriptNode subclass: #SMethodNode
	instanceVariableNames: 'selector pragma'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SMethodNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:41'!
acceptVisitor: visitor
	^visitor visitMethod: self
! !

!SMethodNode methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
buildMethod
	| cm encoder treecodes |
	cm := self methodClass withAll: self literals.
	cm
		blockCount: compiler blockCount;
		tempCount: scope stackSize;
		argumentCount: arguments size;
		environmentCount: scope environmentSize;
		capturesSelf: scope capturesSelf;
		hasEnvironment: self needsEnvironment;
		hasFrame: self needsFrame;
		selector: self selector;
		sourceObject: compiler sourceCode;
		classBinding: compiler frontend classBinding.
	cm pragma: pragma.
	cm blocks do: [ :block | block method: cm ].
	encoder := TreecodeEncoder new method: cm.
	treecodes := self acceptVisitor: encoder.
	^ cm treecodes: treecodes
! !

!SMethodNode methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
captureHome
	
! !

!SMethodNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
compiler: aSmalltalkCompiler
	super compiler: aSmalltalkCompiler.
	scope := MethodScope new script: self.
	pragma := aSmalltalkCompiler pragmaNode
! !

!SMethodNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
environmentIndexOf: aParseNode
	^nil
! !

!SMethodNode methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:41'!
header
	"
	(Object >> #printOn:) ast header
	"
	| interval |
	interval := selector stretch.
	arguments notEmpty
		ifTrue: [interval := interval start thru: arguments last stretch end].
	^compiler sourceCode copyFrom: interval start to: interval end
! !

!SMethodNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isHeadless
	^selector isNil
! !

!SMethodNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isMethod
	^true
! !

!SMethodNode methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
literals
	| literals v l |
	literals := OrderedCollection new.
	pragma isUsed
		ifTrue: [ literals add: pragma name ].
	self
		nodesDo: [ :n | 
			n isLiteral
				ifTrue: [ v := n value.
					v isSmallInteger
						ifFalse: [ literals add: v ] ].
			n isMessageNode
				ifTrue: [ literals add: n symbol ].
			n isBraceNode
				ifTrue: [ n isLiteral
						ifTrue: [ self halt ]
						ifFalse: [ literals
								add: #Array;
								add: #new:;
								add: #at:put:;
								add: #yourself ] ].
			(n isIdentifier
				and: [ l := n binding literal.
					l notNil ])
				ifTrue: [ literals add: l ].
			(n isBlockNode andNot: [ n isInlined ])
				ifTrue: [ literals add: n buildBlock ] ].
	^ literals withoutDuplicates
! !

!SMethodNode methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:41'!
methodClass
	| type |
	type := pragma type.
	type = #callback
		ifTrue: [ ^ CallbackMethod ].
	type = #callout
		ifTrue: [ ^ CalloutMethod ].
	^ CompiledMethod
! !

!SMethodNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
needsEnvironment
	^scope environmentSize > 0
		or: [children anySatisfy: [:block | block usesHome]]
! !

!SMethodNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
needsFrame
	scope stackSize > 0 ifTrue: [ ^ true ].
	arguments size > 16 ifTrue: [ ^ true ].
	compiler hasSends ifTrue: [ ^ true ].
	compiler hasBlocks ifTrue: [ ^ true ].
	^ false
! !

!SMethodNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:41'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	(aBoolean and: [selector notNil]) ifTrue: [aBlock value: selector]
! !

!SMethodNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
pragma
	^pragma
! !

!SMethodNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
pragma: anObject
	pragma := anObject
! !

!SMethodNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
realScript
	^self
! !

!SMethodNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
selector
	^selector value
! !

!SMethodNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
selector: aSelectorNode
	selector := aSelectorNode
! !

!SMethodNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
selectorNode
	^selector
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMethodNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SMethodNode class
	instanceVariableNames: ''!


