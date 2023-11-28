Class {
	#name : #TemplateJIT,
	#superclass : #Object,
	#instVars : [
		'environment',
		'method',
		'remainingBlocks',
		'safepointCheck',
		'mainCode',
		'stackCount',
		'fallbacks',
		'activeScript',
		'assembler'
	],
	#pools : [
		'ClosureElementTypes'
	],
	#category : #Nativization
}

{ #category : #services }
TemplateJIT >> addFallback: aBlock [
	fallbacks add: aBlock
]

{ #category : #services }
TemplateJIT >> argumentAt: index in: envIndex [
	envIndex ifNil: [ ^ self argumentInStackAt: index ].
	envIndex < 0
		ifTrue: [ self argumentInlinedAt: index ]
		ifFalse: [ self argumentInEnvironmentAt: index ]
]

{ #category : #services }
TemplateJIT >> argumentCount [
	^activeScript argumentCount
]

{ #category : #services }
TemplateJIT >> argumentInEnvironmentAt: index [
	assembler loadRwithEindex: index + SClosure instSize
]

{ #category : #services }
TemplateJIT >> argumentInStackAt: index [
	| args end |
	args := self argumentCount.
	method hasFrame ifTrue: [ 
		end := 3 + args.
	assembler loadRwithFPindex: end - index ] ifFalse: [ 
		end := 2 + args.
		assembler  loadRwithSPindex: end - index
	 ]
]

{ #category : #services }
TemplateJIT >> argumentInlinedAt: index [
	self temporaryInStackAt: index
]

{ #category : #services }
TemplateJIT >> associationValueAt: anInteger [
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler
		loadRwithLiteral: literal;
		loadRwithRindex: 2
]

{ #category : #services }
TemplateJIT >> associationValueAt: anInteger put: dummy [
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler
		loadAwithLiteral: literal;
		storeRinAindex: 2;
		pushA.
	self emitWriteBarrier 
]

{ #category : #services }
TemplateJIT >> captureClosure: anSBlock [
	| slot variables |
	self instantiateClosure: anSBlock.
	slot := 3.
	variables := anSBlock capturedVariables readStream.
	[ variables atEnd ]
		whileFalse: [ self captureVariable: variables index: slot.
			slot := slot + 1 ].
	anSBlock capturesHome
		ifTrue: [ self emitSend: #saveHomeFrame ]
]

{ #category : #services }
TemplateJIT >> captureVariable: stream index: anInteger [
	| type pos |
	type := stream next.
	type = nil ifTrue: [^self].
	type = Self ifTrue: [^assembler storeSinRindex: anInteger].
	type = Environment ifTrue: [^assembler storeEinRindex: anInteger].
	pos := stream next.
	type = LocalArgument ifTrue: [
		assembler
			loadTwithFPindex: pos + 2;
			storeTinRindex: anInteger].
	type = EnvironmentValue
		ifTrue: [assembler loadTwithEindex: pos; storeTinRindex: anInteger]
]

{ #category : #services }
TemplateJIT >> constPoolValueAt: anInteger [
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler loadRwithLiteral: literal
]

{ #category : #services }
TemplateJIT >> dropTos [
	assembler dropTos: 1.
	^stackCount := stackCount - 1
]

{ #category : #services }
TemplateJIT >> emitBlockPrologue: anSBlock [
	assembler saveCallerFrame.
	self
		loadBlockSelf: anSBlock compiledCode;
		loadBlockNativeCode;
		pushNativeCode;
		pushEnvironments;
		initializeTemporaries: anSBlock tempCount
]

{ #category : #services }
TemplateJIT >> emitCallbackEpilogue [
	assembler restoreCallerFrame.
	environment abi
		restoreContext: method descriptor with: assembler
]

{ #category : #services }
TemplateJIT >> emitCallbackPrologue [
	| retaddr |
	environment abi emitEntrypoint: method descriptor with: ir.
	retaddr := 0.
	assembler
		pushImm: retaddr;
		xorFPwithFP;
		loadLongMwithIPoffset: 0 - assembler currentAddress + ImageSegmentWriter behaviorOffset;
		loadMwithMindex: SCallbackMethod behaviorNativeCodeSlot;
		loadGwithLiteral: environment globals;
		loadNilWithLiteral: nil;
		loadTrueWithLiteral: true;
		loadFalseWithLiteral: false;
		loadEwithNil;
		loadRwithMindex: (NativeCode indexOfSlot: 'compiledCode');
		loadRwithRindex: (SCallbackMethod indexOfSlot: 'receiver')
]

{ #category : #services }
TemplateJIT >> emitEpilogue [
	method hasBlocks
		ifTrue: [ assembler restoreCallerEnvironment ].
	method isCallback
		ifTrue: [ ^ self emitCallbackEpilogue ].
	method isFrameless
		ifFalse: [ assembler restoreCallerFrame ].
	assembler
		restoreCallerSelf;
		restoreCallerM;
		return
]

{ #category : #services }
TemplateJIT >> emitFFICall [
	self loadObject: method.
	assembler pushR; pushS.
	self emitSend: #_ffiCall:.
	assembler
		restoreCallerFrame;
		restoreCallerSelf;
		restoreCallerM;
		return
]

{ #category : #services }
TemplateJIT >> emitFallbacks [
	fallbacks do: [:block | block value]
]

{ #category : #services }
TemplateJIT >> emitFramedMethodPrologue [
	assembler
		saveCallerFrame;
		pushR;
		initializeS.
	method isCalloutMethod
		ifTrue: [ self emitFFICall ]
		ifFalse: [ self
				pushNativeCode;
				initializeMethodEnvironment;
				initializeMethodTemporaries;
				emitSafepointCheck ]
]

{ #category : #services }
TemplateJIT >> emitFramelessMethodPrologue [
	method capturesSelf
		ifTrue: [ assembler initializeS ]
]

{ #category : #services }
TemplateJIT >> emitMethodPrologue [
	method isCallback
		ifTrue: [ ^self
				emitCallbackPrologue;
				emitFramedMethodPrologue ].
	method isFrameless
		ifTrue: [ self emitFramelessMethodPrologue ]
		ifFalse: [ self emitFramedMethodPrologue ]
]

{ #category : #services }
TemplateJIT >> emitSafepointCheck [
	
]

{ #category : #services }
TemplateJIT >> emitSend: selector [
 	| linker |
	linker := environment messageLinker.
	method isDebuggable
		ifTrue: [ linker emitSendDebuggable: selector using: assembler ]
		ifFalse: [ linker emitSend: selector using: assembler ]
]

{ #category : #services }
TemplateJIT >> emitSend: selector super: aBoolean [
	| linker |
	linker := environment messageLinker.
	
	method isDebuggable
		ifTrue: [ aBoolean ifTrue: [linker emitSendSuperDebuggable: selector from: method classBinding using: ir] ifFalse: [linker emitSendDebuggable: selector using: assembler ]]
		ifFalse: [ aBoolean ifTrue: [linker emitSendSuper: selector from: method classBinding using: assembler ] ifFalse: [linker emitSend: selector using: assembler ]]
]

{ #category : #services }
TemplateJIT >> emitWriteBarrier [
	assembler
		loadAwithGlobal: #WriteBarrier;
		callIndirectA;
		discardArguments: 1
]

{ #category : #accessing }
TemplateJIT >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment.
	assembler := environment platform newAssembler
]

{ #category : #services }
TemplateJIT >> falseLiteral [
	assembler loadRwithFalse
]

{ #category : #initialization }
TemplateJIT >> initialize [
	super initialize.
]

{ #category : #services }
TemplateJIT >> initializeMethodEnvironment [
	method hasBlocks
		ifFalse: [ ^ self ].
	assembler pushE.
	method hasEnvironment
		ifTrue: [ assembler
				pushSmallInteger: method environmentCount;
				loadRwithM.
			self emitSend: #newEnvironment:.
			assembler
				loadEwithR;
				pushE ]
		ifFalse: [ assembler pushNil ]
]

{ #category : #services }
TemplateJIT >> initializeMethodTemporaries [
	self initializeTemporaries: method tempCount
]

{ #category : #services }
TemplateJIT >> initializeTemporaries: count [
	count = 0
		ifTrue: [ ^ self ].
	count <= 6
		ifTrue: [ count timesRepeat: [ assembler pushNil ] ]
		ifFalse: [ assembler
				loop: [ assembler pushNil ] times: count ]
]

{ #category : #services }
TemplateJIT >> instanceVarAt: index [
	assembler loadRwithSindex: index
]

{ #category : #services }
TemplateJIT >> instanceVarAt: index put: value [
	assembler storeRinSindex: index; pushS.
	self emitWriteBarrier
]

{ #category : #services }
TemplateJIT >> instantiateClosure: anSBlock [
	self loadLiteralAt: anSBlock index; emitSend: #newClosure
]

{ #category : #services }
TemplateJIT >> loadAwithArgument: index in: envIndex [
	envIndex
		ifNil: [ ^ self loadAwithArgumentInStackAt: index ]. envIndex < 0
		ifTrue: [ self loadAwithArgumentInlinedAt: index ]
		ifFalse: [ self loadAwithArgumentInEnvironment: envIndex at: index ]
]

{ #category : #services }
TemplateJIT >> loadAwithArgumentInEnvironment: envIndex at: index [
	| offset |
	envIndex = 0
		ifTrue: [ assembler loadAwithEindex: index + SClosure instSize ]
		ifFalse: [ offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadAwithEindex: envIndex + SClosure instSize;
				loadAwithAindex: index + offset ]
]

{ #category : #services }
TemplateJIT >> loadAwithArgumentInStackAt: index [
		| end |
	end := 3 + self argumentCount.
			assembler loadAwithFPindex: end - index

]

{ #category : #services }
TemplateJIT >> loadAwithArgumentInlinedAt: index [
	self loadAwithTemporaryInStackAt: index

]

{ #category : #services }
TemplateJIT >> loadAwithStack: anInteger [
	assembler loadAwithFPindex: 1 - anInteger
]

{ #category : #services }
TemplateJIT >> loadAwithTemporary: index in: envIndex [

	envIndex
		ifNil: [ self loadAwithTemporaryInStackAt: index ]
		ifNotNil: [ 
		self loadAwithTemporaryInEnvironment: envIndex at: index ]
]

{ #category : #services }
TemplateJIT >> loadAwithTemporaryInEnvironment: envIndex at: index [
	| offset |
	envIndex = 0
		ifTrue: [offset := activeScript offsetOfCurrentEnvironment. assembler loadAwithEindex: index + offset ]
		ifFalse: [ offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadAwithEindex: envIndex + SClosure instSize;
				loadAwithAindex: index + offset ]
]

{ #category : #services }
TemplateJIT >> loadAwithTemporaryInStackAt: index [
			| start |
	start := self pushesEnvironments
					 ifTrue: [ -3 ]
					 ifFalse: [ -1 ].
		^ assembler loadAwithFPindex: start - index

]

{ #category : #services }
TemplateJIT >> loadBlockNativeCode [
	| block nativeCode |
	block := SClosure indexOfSlot: 'block'.
	nativeCode := SCompiledBlock indexOfSlot: 'nativeCode'.
	assembler
		loadMwithRindex: block;
		loadMwithMindex: nativeCode
]

{ #category : #services }
TemplateJIT >> loadBlockSelf: aCompiledBlock [
	| offset | 
	aCompiledBlock capturesSelf
		ifTrue: [ offset := aCompiledBlock capturesHome
				ifTrue: [ 1 ]
				ifFalse: [ 0 ].
			assembler loadSwithRindex: SClosure instSize + 1 + offset ]
		ifFalse: [ assembler loadSwithNil ].
	assembler pushS
]

{ #category : #services }
TemplateJIT >> loadLiteralAt: anInteger [
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler loadRwithLiteral: literal
]

{ #category : #services }
TemplateJIT >> loadObject: anObject [
	assembler 	 loadRwithLiteral:  anObject
]

{ #category : #services }
TemplateJIT >> loadRwithStack: anInteger [
	assembler loadRwithFPindex: 1 - anInteger
]

{ #category : #services }
TemplateJIT >> loadTwithStack: anInteger [
	assembler loadTwithFPindex: 1 - anInteger
]

{ #category : #accessing }
TemplateJIT >> method [
	^method
]

{ #category : #services }
TemplateJIT >> methodLiteralAt: anInteger [
	^ method at: anInteger
	
]

{ #category : #services }
TemplateJIT >> methodLiteralFrom: anInteger [
	^ method at: anInteger
]

{ #category : #services }
TemplateJIT >> nativeCode [
	^mainCode
]

{ #category : #services }
TemplateJIT >> nativize [
	method sexpressions acceptVisitor: self.
	[remainingBlocks isEmpty]
		whileFalse: [self nativizeBlock: remainingBlocks removeFirst]
]

{ #category : #services }
TemplateJIT >> nativize: aCompiledMethod [
	self
		resetFor: aCompiledMethod;
		nativize.
	^ aCompiledMethod nativeCode: mainCode
]

{ #category : #services }
TemplateJIT >> nativizeBlock: anSBlock [
	| statements |
	self resetForBlock: anSBlock.
	activeScript := anSBlock.
	self emitBlockPrologue: anSBlock.
	statements := anSBlock statements.
	statements do: [:s | s acceptVisitor: self].
	self saveContextSwitchPoint.
	(statements isEmpty orNot: [statements last isReturn])
		ifTrue: [self emitEpilogue].
	self emitFallbacks.
	anSBlock compiledCode nativeCode: assembler applyFixups nativeCode
]

{ #category : #services }
TemplateJIT >> nilLiteral [
	assembler loadRwithNil
]

{ #category : #services }
TemplateJIT >> popR [
	assembler popR.
	stackCount := stackCount - 1
]

{ #category : #services }
TemplateJIT >> pushEnvironments [
	assembler pushE; loadEwithR; pushE
]

{ #category : #services }
TemplateJIT >> pushNativeCode [
	assembler pushM
]

{ #category : #services }
TemplateJIT >> pushR [
	assembler pushR.
	^stackCount := stackCount + 1
]

{ #category : #services }
TemplateJIT >> pushesEnvironments [
	^method hasBlocks
]

{ #category : #services }
TemplateJIT >> receiver [
	assembler loadRwithS
]

{ #category : #services }
TemplateJIT >> resetFor: aCompiledMethod [
	| fixed |
	method := aCompiledMethod.
	fallbacks := OrderedCollection new.
	remainingBlocks := OrderedCollection new.
	fixed := aCompiledMethod hasBlocks ifTrue: [4] ifFalse: [2].
	stackCount := aCompiledMethod tempCount + fixed.
	assembler reset
]

{ #category : #services }
TemplateJIT >> resetForBlock: anSBlock [ 
	fallbacks := OrderedCollection new.
	stackCount := anSBlock tempCount + 4.
	assembler reset
]

{ #category : #services }
TemplateJIT >> saveContextSwitchPoint [
	method isDebuggable
		ifFalse: [ ^ self ].
	assembler
		pushA;
		pushT;
		pushR.
	environment messageLinker emitSend: #signalStep using: ir.
	assembler
		popR;
		popT;
		popA
]

{ #category : #services }
TemplateJIT >> saveMethodCode [
	mainCode := assembler
					applyFixups;
					nativeCode
]

{ #category : #templates }
TemplateJIT >> sendMustBeBoolean [
	self emitSend: #mustBeBoolean
]

{ #category : #services }
TemplateJIT >> storeRInStack: index [
	assembler storeRinFPindex: 1 - index
]

{ #category : #services }
TemplateJIT >> temporaryAt: index in: envIndex [
	envIndex ifNil: [ self temporaryInStackAt: index ]
ifNotNil: [ self temporaryInEnvironment: envIndex at: index ]
]

{ #category : #services }
TemplateJIT >> temporaryAt: index in: envIndex put: dummy [
	envIndex ifNil: [self temporaryInStackAtPut: index ] ifNotNil: [ 
	self temporaryInEnvironment: envIndex atPut: index]
]

{ #category : #services }
TemplateJIT >> temporaryInEnvironment: envIndex at: index [
	| offset |
	envIndex = 0
		ifTrue: [offset := activeScript offsetOfCurrentEnvironment. assembler loadRwithEindex: index + offset ]
		ifFalse: [ 
			offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadRwithEindex: envIndex + SClosure instSize ;
				loadRwithRindex: index + offset]
]

{ #category : #services }
TemplateJIT >> temporaryInEnvironment: envIndex atPut: index [
	| offset |
	envIndex = 0
		ifTrue: [ offset := activeScript offsetOfCurrentEnvironment.
			assembler
				storeRinEindex: index + offset;
				pushE ]
		ifFalse: [ offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadTwithEindex: envIndex + SClosure instSize ;
				storeRinTindex: index + offset;
				pushT ].
	self emitWriteBarrier
]

{ #category : #services }
TemplateJIT >> temporaryInStackAt: index [
		| start |
	start := self pushesEnvironments
					 ifTrue: [ -3 ]
					 ifFalse: [ -1 ].
		^ assembler loadRwithFPindex: start - index .

]

{ #category : #services }
TemplateJIT >> temporaryInStackAtPut: index [
			| start |
	start := self pushesEnvironments
						 ifTrue: [ -3 ]
						 ifFalse: [ -1 ].
			assembler storeRinFPindex: start - index

]

{ #category : #services }
TemplateJIT >> trueLiteral [
	assembler loadRwithTrue
]

{ #category : #services }
TemplateJIT >> visitAssignment: anSAssignment [
	anSAssignment expression acceptVisitor: self.
	anSAssignment assignees do: [ :a | 
		a binding assign: nil within: self ]
]

{ #category : #services }
TemplateJIT >> visitBlock: anSBlock [
	anSBlock isInlined
		ifTrue: [ ^ anSBlock statements do: [ :s | s acceptVisitor: self ] ].
	remainingBlocks add: anSBlock.
	self captureClosure: anSBlock 
]

{ #category : #services }
TemplateJIT >> visitCascade: anSCascade [
	| receiver index |
	receiver := anSCascade receiver.
	receiver acceptVisitor: self.
	index := self pushR.
	anSCascade messages
		do: [ :m | self visitCascadeMessage: m receiver: index super: receiver isSuper ].
	self dropTos
]

{ #category : #services }
TemplateJIT >> visitCascadeMessage: anSCascadeMessage receiver: index super: aBoolean [
	| arguments |
	arguments := anSCascadeMessage arguments.
	arguments
		do: [ :node | 
			node acceptVisitor: self.
			self pushR ].
	self
		loadRwithStack: index;
		emitSend: anSCascadeMessage selector super: aBoolean.
	stackCount := stackCount - arguments size
]

{ #category : #services }
TemplateJIT >> visitIdentifier: anSIdentifier [
	anSIdentifier binding valueWithin: self
]

{ #category : #services }
TemplateJIT >> visitInlinedMessage: anSMessage [
	| nativizer |
	nativizer := InlinedMessageNativizer new
		message: anSMessage;
		assembler: ir;
		nativizer: self.
	nativizer inlineMessage
]

{ #category : #services }
TemplateJIT >> visitLiteral: anSLiteral [
	| value |
	value := anSLiteral value.
	value isSmallInteger
		ifTrue: [ assembler loadRwithSmallInteger: value ]
		ifFalse: [ self loadLiteralAt: anSLiteral index ]
]

{ #category : #services }
TemplateJIT >> visitMessage: anSMessage [
	| arguments index |
	anSMessage isInlined
		ifTrue: [ ^ self visitInlinedMessage: anSMessage ].
	anSMessage isOptimized
		ifTrue: [ ^ self visitOptimizedMessage: anSMessage ].
	anSMessage receiver acceptVisitor: self.
	arguments := anSMessage arguments.
	arguments isEmpty
		ifFalse: [ index := self pushR.
			arguments
				do: [ :node | 
					node acceptVisitor: self.
					self pushR ].
			self loadRwithStack: index ].
	self emitSend: anSMessage selector super: anSMessage receiver isSuper.
	stackCount := stackCount - arguments size.
	arguments isEmpty
		ifFalse: [ self dropTos ]
]

{ #category : #services }
TemplateJIT >> visitMethod: anSMethod [
	| statements returned |
	activeScript := anSMethod.
	self emitMethodPrologue.
	statements := anSMethod statements.
	statements do: [ :s | s acceptVisitor: self ].
	(statements notEmpty andNot: [ statements last isReturn ])
		ifTrue: [ assembler loadRwithS ].
	returned := statements notEmpty and: [ 	
	statements last isReturn].
	returned ifFalse: [ self emitEpilogue ].
	self
		emitFallbacks;
		saveMethodCode
]

{ #category : #services }
TemplateJIT >> visitOptimizedMessage: anSMessage [
	| nativizer |
	nativizer := BinaryMessageNativizer new
		message: anSMessage;
		assembler: ir;
		nativizer: self.
	nativizer inlineMessage
]

{ #category : #services }
TemplateJIT >> visitReturn: anSReturn [
  anSReturn expression acceptVisitor: self.
  anSReturn local ifTrue: [ self emitEpilogue ] ifFalse: [ assembler
		   pushR;
		   loadRwithE.
		self emitSend: #_return: ] 
]
