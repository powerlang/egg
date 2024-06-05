Class {
	#name : #TreecodeEncoder,
	#superclass : #SParseTreeVisitor,
	#instVars : [
		'method',
		'stream',
		'script'
	],
	#pools : [
		'AstBindingTypes',
		'AstNodeTypes',
		'ClosureElementTypes'
	],
	#category : #'Powerlang-Core-SExpressions'
}

{ #category : #'instance creation' }
TreecodeEncoder class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : #'class initialization' }
TreecodeEncoder class >> initializeTreecodeIds [
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
]

{ #category : #'class initialization' }
TreecodeEncoder class >> initializeBindingIds [
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
]


{ #category : #'class initialization' }
TreecodeEncoder class >> initializeClosureElementIds [
	| named |
	named := self addNamespaceAs: #ClosureElementIds.
	named
		at: #Self put: 0;
		at: #LocalArgument put: 1;
		at: #Environment put: 2;
		at: #EnvironmentValue put: 3
]


{ #category : #visiting }
TreecodeEncoder >> compiledBlockIndexOf: aBlockNode [
	| index |
	index := method
		findFirst: [:literal | literal isBlock
			and: [literal id == aBlockNode index]].
	^index
]

{ #category : #visiting }
TreecodeEncoder >> encodeArgument: anInteger env: environment [
	| encoded |
	encoded := self encodedEnvironment: environment.
	self
		nextPut: ArgumentId;
		nextIntegerPut: anInteger;
		nextIntegerPut: encoded
]

{ #category : #visiting }
TreecodeEncoder >> encodeClosureElements: aBlockNode [
	| scope parent |
	scope := aBlockNode scope.
	parent := aBlockNode realParent.
	^Array streamContents: [:s |
		scope capturesSelf ifTrue: [ s nextPut: Self ].
		scope capturedEnvironments do: [:e | | index |
			e == parent ifTrue: [s nextPut: Environment] ifFalse: [
				index := aBlockNode environmentIndexOf: e.
				self ASSERT: index notNil.
				s nextPut: EnvironmentValue; nextPut: index]].
		scope capturedArguments do: [:a | | binding |
			binding := aBlockNode parent scope resolve: a name.
			s 	nextPut: binding environmentType; nextPut: binding index]]
	
]

{ #category : #visiting }
TreecodeEncoder >> encodeDynamicVar: name [
	stream nextPut: DynamicVarId.
	self nextSymbolPut: name
]

{ #category : #visiting }
TreecodeEncoder >> encodeFalse [
	stream nextPut: FalseId
]

{ #category : #visiting }
TreecodeEncoder >> encodeLoadRvisitingReceiver [
	stream nextPut: LoadRvisitingReceiverId
]

{ #category : #visiting }
TreecodeEncoder >> encodeNestedDynamicVar: name [
	stream nextPut: NestedDynamicVarId.
	self nextLiteralPut: name 
]

{ #category : #visiting }
TreecodeEncoder >> encodeNil [
	stream nextPut: NilId
]

{ #category : #visiting }
TreecodeEncoder >> encodePopR [
	stream nextPut: PopRid 
]

{ #category : #visiting }
TreecodeEncoder >> encodePushR [
	stream nextPut: PushRid 
]

{ #category : #visiting }
TreecodeEncoder >> encodeSelf [
	stream nextPut: SelfId
]

{ #category : #visiting }
TreecodeEncoder >> encodeSuper [
	stream nextPut: SuperId
]

{ #category : #visiting }
TreecodeEncoder >> encodeTemporary: anInteger env: environment [
	| encoded |
	encoded := self encodedEnvironment: environment.
	self
		nextPut: TemporaryId;
		nextIntegerPut: anInteger;
		nextIntegerPut: encoded
]

{ #category : #visiting }
TreecodeEncoder >> encodeTrue [
	stream nextPut: TrueId
]

{ #category : #visiting }
TreecodeEncoder >> encodedEnvironment: aLocalEnvironment [
	aLocalEnvironment isStack
		ifTrue: [ ^ aLocalEnvironment isInlinedArgument
				ifTrue: [ -1 ]
				ifFalse: [ -2 ] ].
	aLocalEnvironment isCurrent
		ifTrue: [ ^ 0 ].
	^ aLocalEnvironment index
]

{ #category : #accessing }
TreecodeEncoder >> initialize [
	stream := #[] writeStream
]

{ #category : #accessing }
TreecodeEncoder >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #visiting }
TreecodeEncoder >> nextBigIntegerPut: anInteger [
	stream
		nextPut: 16r80;
		nextInt64Put: anInteger
]

{ #category : #visiting }
TreecodeEncoder >> nextBooleanPut: aBoolean [
	stream nextPut: aBoolean asParameter

]

{ #category : #visiting }
TreecodeEncoder >> nextIntegerPut: anInteger [
	| value |
	(anInteger > 127 or: [ anInteger < -127 ])
		ifTrue: [ ^ self nextBigIntegerPut: anInteger ].
	value := anInteger >= 0
		ifTrue: [ anInteger ]
		ifFalse: [ anInteger + 16r100 ].
	stream nextPut: value
]

{ #category : #visiting }
TreecodeEncoder >> nextLiteralPut: anObject [
	| index |
	index := method
		indexOf: anObject
		ifAbsent: [ self ASSERT: false ].
	self nextIntegerPut: index
]

{ #category : #visiting }
TreecodeEncoder >> nextPut: anInteger [
	stream nextPut: anInteger
]

{ #category : #visiting }
TreecodeEncoder >> nextPutAll: aCollection [
	stream nextPut: aCollection size; nextPutAll: aCollection
]

{ #category : #visiting }
TreecodeEncoder >> nextSymbolPut: aSymbol [
	| index |
	index := method
		indexOf: aSymbol asSymbol
		ifAbsent: [ self ASSERT: false ].
	self nextIntegerPut: index
]

{ #category : #visiting }
TreecodeEncoder >> nextTypePut: anInteger [
	stream nextPut: anInteger
]

{ #category : #visiting }
TreecodeEncoder >> visitAssignment: anAssignmentNode [
	| assignees |
	self nextTypePut: AssignmentId.
	assignees := anAssignmentNode assignees.
	self nextIntegerPut: assignees size.
	assignees do: [ :node | node acceptVisitor: self ].
	anAssignmentNode expression acceptVisitor: self
]

{ #category : #visiting }
TreecodeEncoder >> visitBlock: aBlockNode [
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
]

{ #category : #visiting }
TreecodeEncoder >> visitBraceNode: aBraceNode [
	aBraceNode isLiteral
		ifTrue: [self visitLiteral: aBraceNode asLiteralNode]
		ifFalse: [self visitCascade: aBraceNode asMessageNode]
]

{ #category : #visiting }
TreecodeEncoder >> visitCascade: aCascadeNode [
	| messages |
	self nextTypePut: CascadeId.
	aCascadeNode receiver acceptVisitor: self.
	messages := aCascadeNode messages.
	self nextIntegerPut: messages size.
	messages do: [ :node | self visitCascadeMessage: node ]
]

{ #category : #visiting }
TreecodeEncoder >> visitCascadeMessage: aCascadeMessageNode [
	| arguments |
	self nextSymbolPut: aCascadeMessageNode selector symbol.
	arguments := aCascadeMessageNode arguments.
	self nextIntegerPut: arguments size.
	arguments do: [ :arg | arg acceptVisitor: self ]
]

{ #category : #visiting }
TreecodeEncoder >> visitIdentifier: anIdentifierNode [
	self nextTypePut: IdentifierId.
	anIdentifierNode binding encodeUsing: self
]

{ #category : #visiting }
TreecodeEncoder >> visitLiteral: aLiteralNode [
	| index |
	index := method indexOf: aLiteralNode value.
	self
		nextTypePut: LiteralId;
		nextIntegerPut: index.
	index = 0
		ifTrue: [ self nextIntegerPut: aLiteralNode value ]
]

{ #category : #visiting }
TreecodeEncoder >> visitMessage: aMessageNode [
	| arguments |
	self
		nextTypePut: MessageId;
		nextBooleanPut: aMessageNode isInlined;
		nextSymbolPut: aMessageNode selector symbol.
	aMessageNode receiver acceptVisitor: self.
	arguments := aMessageNode arguments.
	self nextIntegerPut: arguments size.
	arguments do: [ :arg | arg acceptVisitor: self ]
]

{ #category : #visiting }
TreecodeEncoder >> visitMethod: aMethodNode [
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
]

{ #category : #visiting }
TreecodeEncoder >> visitParseNode: aParseNode [
	^self ASSERT: false
]

{ #category : #visiting }
TreecodeEncoder >> visitReturn: aReturnNode [
	self
		nextTypePut: ReturnId;
		nextBooleanPut: script realScript isMethod.
	
		aReturnNode expression acceptVisitor: self
]

{ #category : #visiting }
TreecodeEncoder >> visitScript: aScriptNode [
	| prev statements |
	prev := script.
	script := aScriptNode.
	statements := aScriptNode statements.
	self nextIntegerPut: statements size.
	statements do: [ :node | node acceptVisitor: self ].
	script := prev
]
