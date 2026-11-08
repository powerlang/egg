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

{ #category : #'class initialization' }
TemplateJIT class >> initializeClosureElementTypes [
	self addNamespaceAs: #ClosureElementTypes.
	ClosureElementTypes
		at: #Self put: 0;
		at: #LocalArgument put: 1;
		at: #Environment put: 2;
		at: #EnvironmentValue put: 3;
		at: #InlinedArgument put: 4
]

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
	assembler loadRwithEindex: index + Closure instSize
]

{ #category : #services }
TemplateJIT >> argumentInStackAt: index [
	| args end |
	args := self argumentCount.
	method hasFrame ifTrue: [ 
		end := 3 + args.
	assembler loadRwithFPindex: end - index ] ifFalse: [ 
		end := args + 1.
		assembler callPushesReturnAddress ifTrue: [end := end + 1].
		assembler loadRwithSPindex: end - index
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
TemplateJIT >> isFloat: type [
	^environment abi isFloat: type
]

{ #category : #services }
TemplateJIT >> loadAssociationValue: anAssociation [
	assembler
		loadRwithLiteral: anAssociation;
		loadRwithRindex: 2
]

{ #category : #services }
TemplateJIT >> storeAssociation: anAssociation value: dummy [
	assembler loadAwithLiteral: anAssociation.
	self storeRinAssociationA
]

{ #category : #services }
TemplateJIT >> storeRinAssociationA [
	assembler storeRinAindex: 2; pushA.
	self emitWriteBarrier
]

{ #category : #services }
TemplateJIT >> bindSiteFor: aSymbol [
	| name |
	name := aSymbol asSymbol.
	method hasFrame: true.
	^BindSite name: name method: method
]

{ #category : #services }
TemplateJIT >> loadBindSite: aSymbol [
	| site index unbound done |
	site := self bindSiteFor: aSymbol.
	index := BindSite indexOfSlot: 'association'.
	unbound := assembler newLabel.
	done := assembler newLabel.
	assembler
		loadRwithLiteral: site;
		loadRwithRindex: index;
		compareRwithNil;
		jumpIfEqualTo: unbound;
		loadRwithRindex: 2;
		jumpTo: done;
		@ unbound;
		loadRwithLiteral: site.
	self emitSend: #value.
	assembler @ done
]

{ #category : #services }
TemplateJIT >> storeBindSite: aSymbol [
	| site index unbound done |
	site := self bindSiteFor: aSymbol.
	index := BindSite indexOfSlot: 'association'.
	unbound := assembler newLabel.
	done := assembler newLabel.
	assembler
		loadAwithLiteral: site;
		loadAwithAindex: index;
		compareWithNil: assembler regA;
		jumpIfEqualTo: unbound.
	self storeRinAssociationA.
	assembler jumpTo: done; @ unbound.
	self pushR.
	assembler loadRwithLiteral: site.
	self emitSend: #value:.
	stackCount := stackCount - 1.
	assembler @ done
]

{ #category : #services }
TemplateJIT >> staticBindingFor: aSymbol [
	| name instVarIndex assoc |
	name := aSymbol asSymbol.
	instVarIndex := method classBinding allInstVarNames indexOf: name.
	instVarIndex > 0 ifTrue: [
		^SInstVarBinding new index: instVarIndex].
	assoc := method associationFor: name.
	assoc ifNotNil: [^SAssociationBinding new association: assoc].
	assoc := LMRProtoObject module namespace associationAt: name ifAbsent: [nil].
	assoc ifNotNil: [^SAssociationBinding new association: assoc].
	Kernel host logWarning: 'undeclared ' , name , ' in ' , method classBinding name , '>>' , method selector.
	^nil
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
			loadTwithFPindex: 3 + self argumentCount - pos;
			storeTinRindex: anInteger].
	type = EnvironmentValue
		ifTrue: [assembler loadTwithEindex: pos + activeScript offsetOfCurrentEnvironment; storeTinRindex: anInteger]
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
TemplateJIT >> emitCallbackArguments [
	method argumentCount = 0 ifTrue: [^self].
	self emitCallbackDecoding.
	assembler loadAwithR.
	1 to: method argumentCount do: [:i |
		assembler
			loadRwithA;
			loadRwithRindex: i;
			pushR]
]

{ #category : #services }
TemplateJIT >> emitCallbackDecoding [
	| offsets index |
	offsets := environment abi callbackOffsetsOf: method descriptor.
	index := NativeCode indexOfSlot: 'compiledCode'.
	self emitFramedSend: #argumentsAt:offsets: loading: [
		assembler
			loadRwithFPindex: 3;
			pushR;
			loadRwithLiteral: offsets;
			pushR;
			loadRwithMindex: index]
]

{ #category : #services }
TemplateJIT >> emitCallbackEnter [
	self emitFramedSend: #enterCallback loading: [self loadObject: ProcessLMRStack]
]

{ #category : #services }
TemplateJIT >> emitCallbackEpilogue [
	self
		emitCallbackResult;
		loadObject: ProcessLMRStack;
		emitSend: #exitCallback.
	assembler restoreCallerFrame.
	environment abi
		restoreContext: method descriptor with: assembler
]

{ #category : #services }
TemplateJIT >> emitCallbackPrologue [
	environment abi emitEntrypoint: method descriptor with: assembler.
	assembler
		xorFPwithFP;
		loadMwithOwnNativeCode: environment platform behaviorOffset;
		loadGwithLiteral: environment lmrModule globals;
		loadNilWithLiteral: nil;
		loadTrueWithLiteral: true;
		loadFalseWithLiteral: false;
		loadEwithNil.
	self emitCallbackEnter; emitCallbackArguments.
	assembler callPushesReturnAddress ifTrue: [assembler pushImm: 0].
	assembler
		loadRwithMindex: (NativeCode indexOfSlot: 'compiledCode');
		loadRwithRindex: (CallbackMethod indexOfSlot: 'receiver')
]

{ #category : #services }
TemplateJIT >> emitCallbackResult [
	method descriptor returnTypeName == #void ifTrue: [^self].
	assembler
		pushR;
		loadRwithFPindex: 3 + method argumentCount;
		pushR.
	self
		loadObject: method;
		emitSend: #store:at:
]

{ #category : #services }
TemplateJIT >> emitFramedSend: aSymbol loading: aBlock [
	assembler callPushesReturnAddress ifTrue: [assembler pushImm: 0].
	assembler
		saveCallerFrame;
		pushNil.
	self pushNativeCode.
	aBlock value.
	self emitSend: aSymbol.
	assembler restoreCallerFrame.
	assembler callPushesReturnAddress ifTrue: [assembler popA]
]

{ #category : #services }
TemplateJIT >> emitCallout [
	| descriptor types return index lookup resolved buffer |
	descriptor := method descriptor.
	types := descriptor argumentTypeNames.
	return := descriptor returnTypeName.
	index := method class indexOfSlot: 'address'.
	lookup := assembler newLabel.
	resolved := assembler newLabel.
	assembler @ resolved.
	self loadObject: method.
	assembler
		loadRwithRindex: index;
		compareRwithNil;
		jumpIfEqualTo: lookup.
	self addFallback: [
		assembler @ lookup; pushS.
		self loadObject: method; emitSend: #lookupFor:.
		assembler jumpTo: resolved].
	buffer := self emitMarshalling: types size.
	self emitChunkTop; loadObject: method.
	assembler
		loadRwithRindex: index;
		convertRtoNativeInteger.
	environment abi
		emitCallout: types
		with: assembler
		loading: [:i |
			self loadRwithStack: buffer.
			assembler loadRwithRindex: i].
	self emitCalloutResult: return in: buffer
]

{ #category : #services }
TemplateJIT >> emitChunkTop [
	assembler codegen move: assembler regSP to: assembler regR.
	assembler
		setRintegerBit;
		pushR;
		loadRwithFP;
		setRintegerBit;
		pushR.
	self loadObject: ProcessLMRStack; emitSend: #calloutTop:frame:
]

{ #category : #services }
TemplateJIT >> emitCalloutResult: type in: buffer [
	type == #void ifTrue: [^assembler loadRwithImmediate: 1].
	environment abi extendResult: type with: assembler.
	(self isFloat: type) ifTrue: [assembler moveX0toR].
	self loadAwithStack: buffer.
	assembler storeRinAindex: 1.
	self loadObject: method descriptor; emitSend: #resultFrom:.
	stackCount := stackCount - 1
]

{ #category : #services }
TemplateJIT >> emitMarshalling: count [
	| arguments |
	assembler loadRwithSmallInteger: count.
	self pushR; loadObject: Array; emitSend: #new:.
	stackCount := stackCount - 1.
	arguments := self pushR.
	1 to: count do: [:i |
		self argumentInStackAt: i; loadAwithStack: arguments.
		assembler storeRinAindex: i; pushA.
		self emitWriteBarrier].
	self loadObject: method descriptor; emitSend: #marshalArguments:.
	stackCount := stackCount - 1.
	^self pushR
]

{ #category : #services }
TemplateJIT >> emitEpilogue [
	method hasBlocks
		ifTrue: [ assembler restoreCallerEnvironment ].
	(method isCallback and: [ activeScript isMethod ])
		ifTrue: [ ^ self emitCallbackEpilogue ].
	method isFrameless
		ifFalse: [ assembler restoreCallerFrame ].
	assembler
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
	self
		pushNativeCode;
		initializeMethodEnvironment;
		initializeMethodTemporaries;
		emitSafepointCheck
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
		ifTrue: [ aBoolean ifTrue: [linker emitSendSuperDebuggable: selector from: method classBinding using: assembler] ifFalse: [linker emitSendDebuggable: selector using: assembler ]]
		ifFalse: [ aBoolean ifTrue: [linker emitSendSuper: selector from: method classBinding using: assembler ] ifFalse: [linker emitSend: selector using: assembler ]]
]

{ #category : #services }
TemplateJIT >> inlinesBinary: anSMessage [
	| selector |
	anSMessage receiver isSuper ifTrue: [ ^ false ].
	anSMessage arguments size = 1 ifFalse: [ ^ false ].
	selector := anSMessage selector.
	selector isSymbol ifFalse: [ selector := method at: selector ].
	^ BinaryMessageNativizer inlinedSelectors includes: selector
]

{ #category : #services }
TemplateJIT >> emitWriteBarrier [
	| saving |
	saving := method isFrameless and: [assembler callPushesReturnAddress not].
	saving ifTrue: [assembler popT; saveReturnAddress; pushT].
	assembler
		loadAwithGlobal: #WriteBarrier;
		callIndirectA;
		discardArguments: 1.
	saving ifTrue: [assembler restoreReturnAddress]
]

{ #category : #accessing }
TemplateJIT >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment.
	assembler := environment newAssembler
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
		ifTrue: [ assembler loadAwithEindex: index + Closure instSize ]
		ifFalse: [ offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadAwithEindex: envIndex + Closure instSize;
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
				loadAwithEindex: envIndex + Closure instSize;
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
	block := Closure indexOfSlot: 'block'.
	nativeCode := CompiledBlock indexOfSlot: 'optimizedCode'.
	assembler
		loadMwithRindex: block;
		loadMwithMindex: nativeCode
]

{ #category : #services }
TemplateJIT >> loadBlockSelf: aCompiledBlock [
	aCompiledBlock capturesSelf
		ifTrue: [ assembler loadSwithRindex: Closure instSize + 1 ]
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
	| framed |
	framed := aCompiledMethod hasFrame.
	self resetFor: aCompiledMethod; nativize.
	framed = aCompiledMethod hasFrame ifFalse: [self resetFor: aCompiledMethod; nativize].
	^ aCompiledMethod optimizedCode: mainCode
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
	anSBlock compiledCode optimizedCode: assembler applyFixups nativeCode
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
	environment messageLinker emitSend: #signalStep using: assembler.
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
				loadRwithEindex: envIndex + Closure instSize ;
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
				loadTwithEindex: envIndex + Closure instSize ;
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
		assembler: assembler;
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
	(anSMessage isOptimized or: [ self inlinesBinary: anSMessage ])
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
	method isCalloutMethod ifTrue: [
		self emitCallout; emitEpilogue; emitFallbacks; saveMethodCode.
		^self].
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
		assembler: assembler;
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
