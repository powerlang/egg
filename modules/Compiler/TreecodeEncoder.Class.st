'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TreecodeEncoder category: #'Powerlang-Core-SExpressions'!
SParseTreeVisitor subclass: #TreecodeEncoder
	instanceVariableNames: 'method stream script'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiledBlockIndexOf: aBlockNode
	| index |
	index := method
		findFirst: [:literal | literal isBlock
			and: [literal blockNumber == aBlockNode index]].
	^index
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeArgument: anInteger env: environment
	| encoded |
	encoded := self encodedEnvironment: environment.
	self
		nextPut: ArgumentId;
		nextIntegerPut: anInteger;
		nextIntegerPut: encoded
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeClosureElements: aBlockNode
	| scope parent |
	scope := aBlockNode scope.
	parent := aBlockNode realParent.
	^Array streamContents: [:s |
		scope capturesSelf ifTrue: [ s nextPut: CaptureSelf ].
		scope capturedEnvironments do: [:e | | index |
			e == parent ifTrue: [s nextPut: CaptureEnvironment] ifFalse: [
				index := aBlockNode environmentIndexOf: e.
				self ASSERT: index notNil.
				s nextPut: CaptureEnvironmentValue; nextPut: index]].
		scope capturedArguments do: [:a | | binding |
			binding := aBlockNode parent scope resolve: a name.
			s 	nextPut: binding environmentCaptureType; nextPut: binding index]]
	
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeDynamicVar: name
	stream nextPut: DynamicVarId.
	self nextSymbolPut: name
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFalse
	stream nextPut: FalseId
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeLoadRvisitingReceiver
	stream nextPut: LoadRvisitingReceiverId
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeNestedDynamicVar: name
	stream nextPut: NestedDynamicVarId.
	self nextLiteralPut: name 
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeNil
	stream nextPut: NilId
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodePopR
	stream nextPut: PopRid 
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodePushR
	stream nextPut: PushRid 
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeSelf
	stream nextPut: SelfId
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeSuper
	stream nextPut: SuperId
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeTemporary: anInteger env: environment
	| encoded |
	encoded := self encodedEnvironment: environment.
	self
		nextPut: TemporaryId;
		nextIntegerPut: anInteger;
		nextIntegerPut: encoded
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeTrue
	stream nextPut: TrueId
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodedEnvironment: aLocalEnvironment
	aLocalEnvironment isStack
		ifTrue: [ ^ aLocalEnvironment isInlinedArgument
				ifTrue: [ -1 ]
				ifFalse: [ -2 ] ].
	aLocalEnvironment isCurrent
		ifTrue: [ ^ 0 ].
	^ aLocalEnvironment index
! !

!TreecodeEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	stream := #[] writeStream
! !

!TreecodeEncoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
method: aCompiledMethod
	method := aCompiledMethod
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextBigIntegerPut: anInteger
	stream
		nextPut: 16r80;
		nextInt64Put: anInteger
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextBooleanPut: aBoolean
	stream nextPut: aBoolean asParameter

! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextIntegerPut: anInteger
	| value |
	(anInteger > 127 or: [ anInteger < -127 ])
		ifTrue: [ ^ self nextBigIntegerPut: anInteger ].
	value := anInteger >= 0
		ifTrue: [ anInteger ]
		ifFalse: [ anInteger + 16r100 ].
	stream nextPut: value
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextLiteralPut: anObject
	| index |
	index := method
		indexOf: anObject
		ifAbsent: [ self ASSERT: false ].
	self nextIntegerPut: index
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextPut: anInteger
	stream nextPut: anInteger
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextPutAll: aCollection
	stream nextPut: aCollection size; nextPutAll: aCollection
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextSymbolPut: aSymbol
	| index |
	index := method
		indexOf: aSymbol asSymbol
		ifAbsent: [ self ASSERT: false ].
	self nextIntegerPut: index
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextTypePut: anInteger
	stream nextPut: anInteger
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitAssignment: anAssignmentNode
	| assignees |
	self nextTypePut: AssignmentId.
	assignees := anAssignmentNode assignees.
	self nextIntegerPut: assignees size.
	assignees do: [ :node | node acceptVisitor: self ].
	anAssignmentNode expression acceptVisitor: self
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitBlock: aBlockNode
	| args inlined |
	self nextTypePut: BlockId.
	inlined := aBlockNode isInlined.
	self nextBooleanPut: inlined.
	inlined
		ifTrue: [ args := aBlockNode arguments collect: [ :id | id binding index ].
			self nextPutAll: args asArray ]
		ifFalse: [ | index captured |
			index := self compiledBlockIndexOf: aBlockNode.
			self nextPut: index.
			captured := self encodeClosureElements: aBlockNode.
			self nextPutAll: captured ].
	self visitScript: aBlockNode
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitBraceNode: aBraceNode
	aBraceNode isLiteral
		ifTrue: [self visitLiteral: aBraceNode asLiteralNode]
		ifFalse: [self visitCascade: aBraceNode asMessageNode]
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitCascade: aCascadeNode
	| messages |
	self nextTypePut: CascadeId.
	aCascadeNode receiver acceptVisitor: self.
	messages := aCascadeNode messages.
	self nextIntegerPut: messages size.
	messages do: [ :node | self visitCascadeMessage: node ]
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitCascadeMessage: aCascadeMessageNode
	| arguments |
	self nextSymbolPut: aCascadeMessageNode selector symbol.
	arguments := aCascadeMessageNode arguments.
	self nextIntegerPut: arguments size.
	arguments do: [ :arg | arg acceptVisitor: self ]
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitIdentifier: anIdentifierNode
	self nextTypePut: IdentifierId.
	anIdentifierNode binding encodeUsing: self
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitLiteral: aLiteralNode
	| index |
	index := method indexOf: aLiteralNode value.
	self
		nextTypePut: LiteralId;
		nextIntegerPut: index.
	index = 0
		ifTrue: [ self nextIntegerPut: aLiteralNode value ]
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMessage: aMessageNode
	| arguments |
	self
		nextTypePut: MessageId;
		nextBooleanPut: aMessageNode isInlined;
		nextSymbolPut: aMessageNode selector symbol.
	aMessageNode receiver acceptVisitor: self.
	arguments := aMessageNode arguments.
	self nextIntegerPut: arguments size.
	arguments do: [ :arg | arg acceptVisitor: self ]
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMethod: aMethodNode
	| pragma |
	self nextTypePut: MethodId.
	pragma := aMethodNode pragma.
	pragma isUsed
		ifTrue: [ self nextTypePut: PragmaId.
			pragma name
				ifNotNil: [ self nextSymbolPut: pragma name ]
				ifNil: [ self nextPut: 0 ] ].
	self visitScript: aMethodNode.
	^ stream contents 
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitParseNode: aParseNode
	^self ASSERT: false
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitReturn: aReturnNode
	self
		nextTypePut: ReturnId;
		nextBooleanPut: script realScript isMethod.
	
		aReturnNode expression acceptVisitor: self
! !

!TreecodeEncoder methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitScript: aScriptNode
	| prev statements |
	prev := script.
	script := aScriptNode.
	statements := aScriptNode statements.
	self nextIntegerPut: statements size.
	statements do: [ :node | node acceptVisitor: self ].
	script := prev
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TreecodeEncoder class' category: #'Powerlang-Core-SExpressions'!
TreecodeEncoder class
	instanceVariableNames: ''!

!TreecodeEncoder class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeTreecodeIds
	| named |
	named := self addNamespaceAs: #TreecodeIds.
	named
		at: #MethodId put: 101;
		at: #BlockId put: 102;
		at: #IdentifierId put: 103;
		at: #LiteralId put: 104;
		at: #MessageId put: 105;
		at: #CascadeId put: 106;
		at: #BraceId put: 107;
		at: #AssignmentId put: 108;
		at: #ReturnId put: 109;
		at: #PragmaId put: 110
! !

!TreecodeEncoder class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeBindingIds
	| named |
	named := self addNamespaceAs: #BindingIds.
	named
		at: #NilId put: 1;
		at: #TrueId put: 2;
		at: #FalseId put: 3;
		at: #ArgumentId put: 4;
		at: #TemporaryId put: 5;
		at: #SelfId put: 6;
		at: #SuperId put: 7;
		at: #DynamicVarId put: 14;
		at: #NestedDynamicVarId put: 15;
		at: #PushRid put: 50;
		at: #PopRid put: 51
! !


TreecodeEncoder initialize!

