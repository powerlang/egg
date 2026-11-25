'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #TreecodeDecoder category: 'Powerlang-Core-SExpressions'!
Object subclass: #TreecodeDecoder
	instanceVariableNames: 'method stream builder'
	classVariableNames: 'BindingTypes NodeTypes'
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
bindingTypeOf: id
	^ BindingTypes at: id
! !

!TreecodeDecoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
builder: aRuntime
	builder := aRuntime
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeArgument
	^ SArgumentBinding new
		index: self nextInteger;
		environment: self nextEnvironment
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeAssignment
	| assignment assignees |
	assignment := SAssignment new.
	
	assignees := self nextExpressionArray.
	assignment expression: self nextExpression.
	assignees do: [ :identifier | assignment assign: identifier ].
	^ assignment
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeBlock

	| expression inlined block index code |
	expression := SBlock new.
	inlined := self nextBoolean.
	inlined
		ifTrue: [ expression inlinedArgs: self nextArray ]
		ifFalse: [ 
			index := self nextInteger.
			block := self literalAt: index.
			builder ifNotNil: [ 
				code := builder newExecutableCodeFor: expression.
				builder blockExecutableCode: block put: code ].
			expression
				compiledCode: block;
				index: index;
				capturedVariables: self nextArray ].
	expression statements: self nextExpressionArray.
	^ expression
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeCascade
	| cascade receiver messages message count |
	cascade := SCascade new.
	receiver := self nextExpression.
	count := self nextInteger.
	messages := (1 to: count)
		collect: [ :i | 
			message := SCascadeMessage decodeUsing: self.
			message cascade: cascade ].
	^ cascade
		receiver: receiver;
		messages: messages
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeCascadeMessage
	| selector arguments |
	selector := self nextSymbol.
	arguments := self nextExpressionArray.
	^ SCascadeMessage new
		selector: selector;
		arguments: arguments
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeDynamicVar
	^ SDynamicBinding new name: self nextSymbol
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeIdentifier
	| type binding |
	type := self bindingTypeOf: self nextInteger.
	binding := type decodeUsing: self.
	^ SIdentifier new binding: binding
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeLiteral
	| index value |
	index := self nextInteger.
	value := index = 0
		ifTrue: [ self nextLiteralInteger ]
		ifFalse: [ self literalAt: index ].
	^ SLiteral new
		index: index;
		value: value
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeMessage
	| inlined selector receiver arguments |
	inlined := self nextBoolean.
	selector := self nextSymbol.
	receiver := self nextExpression.
	arguments := self nextExpressionArray.
	^ SMessage new
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		inlined: inlined
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeMethod
	| type node next pragma |
	type := stream next.
	type !!= MethodId
		ifTrue: [ self error: 'method treecode expected' ].
	node := SMethod new.
	next := stream peek.
	next = PragmaId
		ifTrue: [ stream next.
			pragma := SPragma new name: self nextSymbolOrNil.
			node pragma: pragma ].
	node
		compiledCode: method;
		statements: self nextExpressionArray.
	^ node
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeNestedDynamicVar
	^ SNestedDynamicBinding new
		name:
			self nextSymbol.

! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeReturn
	| expression local |
	local := self nextBoolean.
	expression := self nextExpression.
	^ SReturn new
		local: local;
		expression: expression
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeTemporary
	^ STemporaryBinding new
		index: self nextInteger;
		environment: self nextEnvironment
! !

!TreecodeDecoder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
literalAt: anInteger
	^ builder ifNil: [method at: anInteger] ifNotNil: [builder method: method literalAt: anInteger]
! !

!TreecodeDecoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
method: aMethod
	method := aMethod
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextArray
	| count |
	count := self nextInteger.
	^ stream next: count
! !

!TreecodeDecoder methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextBoolean
	^ stream next = 1
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextEnvironment
	| value |
	value := self nextInteger.
	^ value !!= -2
		ifTrue: [ value ]
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextExpression
	| type |
	type := self nodeTypeOf: stream next.
	^type decodeUsing: self.

! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextExpressionArray
	| count |
	count := self nextInteger.
	^(1 to: count) collect: [ :arg | self nextExpression ]
! !

!TreecodeDecoder methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextInteger
	| value |
	value := stream next.
	value = 16r80
		ifTrue: [ ^ stream int64 ].
	^ value <= 127
		ifTrue: [ value ]
		ifFalse: [ value - 16r100 ]
! !

!TreecodeDecoder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextLiteralInteger
	| value |
	value := self nextInteger.
	^ builder
		ifNil: [ value ]
		ifNotNil: [ builder newInteger: value ]
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextSymbol
	| index |
	index := self nextInteger.
	^ self literalAt: index
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextSymbolOrNil
	| index |
	index := self nextInteger.
	^index !!= 0 ifTrue: [ self literalAt: index]
! !

!TreecodeDecoder methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextUnsignedInteger
	| value |
	value := self nextByte.
	^value < 128
		ifTrue: [value]
		ifFalse: [value - 128 + (self nextUnsignedInteger bitShift: 7)]
! !

!TreecodeDecoder methodsFor:  'public' stamp: 'KenD 28/Jun/2026 13:27:39'!
nodeTypeOf: id
	^NodeTypes at: id
! !

!TreecodeDecoder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
stream: aStream
	stream := aStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TreecodeDecoder class' category: 'Powerlang-Core-SExpressions'!
TreecodeDecoder class
	instanceVariableNames: 'BindingTypes NodeTypes'!

!TreecodeDecoder class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializePools
	"TODO: would be best to share this code with encoder. However, both can be loaded (or not) independently"
	self addNamespaceAs: #BindingIds.
	BindingIds
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
		at: #PopRid put: 51.

	self addNamespaceAs: #TreecodeIds.
	TreecodeIds
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

!TreecodeDecoder class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeBindingTypes
	BindingTypes := Dictionary new.
	BindingTypes
		at: NilId put: SNilBinding;
		at: TrueId put: STrueBinding;
		at: FalseId put: SFalseBinding;
		at: ArgumentId put: SArgumentBinding;
		at: TemporaryId put: STemporaryBinding;
		at: SelfId put: SSelfBinding;
		at: SuperId put: SSuperBinding;
		at: DynamicVarId put: SDynamicBinding;
		at: NestedDynamicVarId put: SNestedDynamicBinding
! !

!TreecodeDecoder class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeNodeTypes
	NodeTypes := Dictionary new.
	NodeTypes
		at: AssignmentId put: SAssignment;
		at: BlockId put: SBlock;
		at: CascadeId put: SCascade;
		at: LiteralId put: SLiteral;
		at: IdentifierId put: SIdentifier;
		at: MessageId put: SMessage;
		at: ReturnId put: SReturn
! !


