'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TemplateJIT category: #Nativization!
Object subclass: #TemplateJIT
	instanceVariableNames: 'environment method remainingBlocks safepointCheck mainCode stackCount fallbacks activeScript assembler'
	classVariableNames: ''
	poolDictionaries: 'ClosureElementTypes'
	category: 'Nativization'!
!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
addFallback: aBlock
	fallbacks add: aBlock
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
argumentAt: index in: envIndex
	envIndex ifNil: [ ^ self argumentInStackAt: index ].
	envIndex < 0
		ifTrue: [ self argumentInlinedAt: index ]
		ifFalse: [ self argumentInEnvironmentAt: index ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
argumentCount
	^activeScript argumentCount
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
argumentInEnvironmentAt: index
	assembler loadRwithEindex: index + SClosure instSize
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
argumentInStackAt: index
	| args end |
	args := self argumentCount.
	method hasFrame ifTrue: [ 
		end := 3 + args.
	assembler loadRwithFPindex: end - index ] ifFalse: [ 
		end := 2 + args.
		assembler  loadRwithSPindex: end - index
	 ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
argumentInlinedAt: index
	self temporaryInStackAt: index
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
associationValueAt: anInteger
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler
		loadRwithLiteral: literal;
		loadRwithRindex: 2
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
associationValueAt: anInteger put: dummy
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler
		loadAwithLiteral: literal;
		storeRinAindex: 2;
		pushA.
	self emitWriteBarrier 
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureClosure: anSBlock
	| slot variables |
	self instantiateClosure: anSBlock.
	slot := 3.
	variables := anSBlock capturedVariables readStream.
	[ variables atEnd ]
		whileFalse: [ self captureVariable: variables index: slot.
			slot := slot + 1 ].
	anSBlock capturesHome
		ifTrue: [ self emitSend: #saveHomeFrame ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureVariable: stream index: anInteger
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
constPoolValueAt: anInteger
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler loadRwithLiteral: literal
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
dropTos
	assembler dropTos: 1.
	^stackCount := stackCount - 1
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitBlockPrologue: anSBlock
	assembler saveCallerFrame.
	self
		loadBlockSelf: anSBlock compiledCode;
		loadBlockNativeCode;
		pushNativeCode;
		pushEnvironments;
		initializeTemporaries: anSBlock tempCount
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitCallbackEpilogue
	assembler restoreCallerFrame.
	environment abi
		restoreContext: method descriptor with: assembler
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitCallbackPrologue
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitEpilogue
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitFFICall
	self loadObject: method.
	assembler pushR; pushS.
	self emitSend: #_ffiCall:.
	assembler
		restoreCallerFrame;
		restoreCallerSelf;
		restoreCallerM;
		return
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitFallbacks
	fallbacks do: [:block | block value]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitFramedMethodPrologue
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitFramelessMethodPrologue
	method capturesSelf
		ifTrue: [ assembler initializeS ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitMethodPrologue
	method isCallback
		ifTrue: [ ^self
				emitCallbackPrologue;
				emitFramedMethodPrologue ].
	method isFrameless
		ifTrue: [ self emitFramelessMethodPrologue ]
		ifFalse: [ self emitFramedMethodPrologue ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitSafepointCheck
	
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitSend: selector
 	| linker |
	linker := environment messageLinker.
	method isDebuggable
		ifTrue: [ linker emitSendDebuggable: selector using: assembler ]
		ifFalse: [ linker emitSend: selector using: assembler ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitSend: selector super: aBoolean
	| linker |
	linker := environment messageLinker.
	
	method isDebuggable
		ifTrue: [ aBoolean ifTrue: [linker emitSendSuperDebuggable: selector from: method classBinding using: ir] ifFalse: [linker emitSendDebuggable: selector using: assembler ]]
		ifFalse: [ aBoolean ifTrue: [linker emitSendSuper: selector from: method classBinding using: assembler ] ifFalse: [linker emitSend: selector using: assembler ]]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitWriteBarrier
	assembler
		loadAwithGlobal: #WriteBarrier;
		callIndirectA;
		discardArguments: 1
! !

!TemplateJIT methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environment: aNativizationEnvironment
	environment := aNativizationEnvironment.
	assembler := environment newAssembler
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
falseLiteral
	assembler loadRwithFalse
! !

!TemplateJIT methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeMethodEnvironment
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeMethodTemporaries
	self initializeTemporaries: method tempCount
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeTemporaries: count
	count = 0
		ifTrue: [ ^ self ].
	count <= 6
		ifTrue: [ count timesRepeat: [ assembler pushNil ] ]
		ifFalse: [ assembler
				loop: [ assembler pushNil ] times: count ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
instanceVarAt: index
	assembler loadRwithSindex: index
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
instanceVarAt: index put: value
	assembler storeRinSindex: index; pushS.
	self emitWriteBarrier
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
instantiateClosure: anSBlock
	self loadLiteralAt: anSBlock index; emitSend: #newClosure
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithArgument: index in: envIndex
	envIndex
		ifNil: [ ^ self loadAwithArgumentInStackAt: index ]. envIndex < 0
		ifTrue: [ self loadAwithArgumentInlinedAt: index ]
		ifFalse: [ self loadAwithArgumentInEnvironment: envIndex at: index ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithArgumentInEnvironment: envIndex at: index
	| offset |
	envIndex = 0
		ifTrue: [ assembler loadAwithEindex: index + SClosure instSize ]
		ifFalse: [ offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadAwithEindex: envIndex + SClosure instSize;
				loadAwithAindex: index + offset ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithArgumentInStackAt: index
		| end |
	end := 3 + self argumentCount.
			assembler loadAwithFPindex: end - index

! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithArgumentInlinedAt: index
	self loadAwithTemporaryInStackAt: index

! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithStack: anInteger
	assembler loadAwithFPindex: 1 - anInteger
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithTemporary: index in: envIndex

	envIndex
		ifNil: [ self loadAwithTemporaryInStackAt: index ]
		ifNotNil: [ 
		self loadAwithTemporaryInEnvironment: envIndex at: index ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithTemporaryInEnvironment: envIndex at: index
	| offset |
	envIndex = 0
		ifTrue: [offset := activeScript offsetOfCurrentEnvironment. assembler loadAwithEindex: index + offset ]
		ifFalse: [ offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadAwithEindex: envIndex + SClosure instSize;
				loadAwithAindex: index + offset ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithTemporaryInStackAt: index
			| start |
	start := self pushesEnvironments
					 ifTrue: [ -3 ]
					 ifFalse: [ -1 ].
		^ assembler loadAwithFPindex: start - index

! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadBlockNativeCode
	| block nativeCode |
	block := SClosure indexOfSlot: 'block'.
	nativeCode := SCompiledBlock indexOfSlot: 'nativeCode'.
	assembler
		loadMwithRindex: block;
		loadMwithMindex: nativeCode
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadBlockSelf: aCompiledBlock
	| offset | 
	aCompiledBlock capturesSelf
		ifTrue: [ offset := aCompiledBlock capturesHome
				ifTrue: [ 1 ]
				ifFalse: [ 0 ].
			assembler loadSwithRindex: SClosure instSize + 1 + offset ]
		ifFalse: [ assembler loadSwithNil ].
	assembler pushS
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLiteralAt: anInteger
	| literal |
	literal := self methodLiteralAt: anInteger.
	assembler loadRwithLiteral: literal
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadObject: anObject
	assembler 	 loadRwithLiteral:  anObject
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithStack: anInteger
	assembler loadRwithFPindex: 1 - anInteger
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithStack: anInteger
	assembler loadTwithFPindex: 1 - anInteger
! !

!TemplateJIT methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
method
	^method
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodLiteralAt: anInteger
	^ method at: anInteger
	
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodLiteralFrom: anInteger
	^ method at: anInteger
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativeCode
	^mainCode
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativize
	method sexpressions acceptVisitor: self.
	[remainingBlocks isEmpty]
		whileFalse: [self nativizeBlock: remainingBlocks removeFirst]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativize: aCompiledMethod
	self
		resetFor: aCompiledMethod;
		nativize.
	^ aCompiledMethod optimizedCode: mainCode
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeBlock: anSBlock
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nilLiteral
	assembler loadRwithNil
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
popR
	assembler popR.
	stackCount := stackCount - 1
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushEnvironments
	assembler pushE; loadEwithR; pushE
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushNativeCode
	assembler pushM
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushR
	assembler pushR.
	^stackCount := stackCount + 1
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushesEnvironments
	^method hasBlocks
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
receiver
	assembler loadRwithS
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
resetFor: aCompiledMethod
	| fixed |
	method := aCompiledMethod.
	fallbacks := OrderedCollection new.
	remainingBlocks := OrderedCollection new.
	fixed := aCompiledMethod hasBlocks ifTrue: [4] ifFalse: [2].
	stackCount := aCompiledMethod tempCount + fixed.
	assembler reset
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
resetForBlock: anSBlock
	fallbacks := OrderedCollection new.
	stackCount := anSBlock tempCount + 4.
	assembler reset
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
saveContextSwitchPoint
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
saveMethodCode
	mainCode := assembler
					applyFixups;
					nativeCode
! !

!TemplateJIT methodsFor:  'templates' stamp: 'KenD 28/Jun/2026 13:27:40'!
sendMustBeBoolean
	self emitSend: #mustBeBoolean
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRInStack: index
	assembler storeRinFPindex: 1 - index
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaryAt: index in: envIndex
	envIndex ifNil: [ self temporaryInStackAt: index ]
ifNotNil: [ self temporaryInEnvironment: envIndex at: index ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaryAt: index in: envIndex put: dummy
	envIndex ifNil: [self temporaryInStackAtPut: index ] ifNotNil: [ 
	self temporaryInEnvironment: envIndex atPut: index]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaryInEnvironment: envIndex at: index
	| offset |
	envIndex = 0
		ifTrue: [offset := activeScript offsetOfCurrentEnvironment. assembler loadRwithEindex: index + offset ]
		ifFalse: [ 
			offset := activeScript offsetOfEnvironment: envIndex.
			assembler
				loadRwithEindex: envIndex + SClosure instSize ;
				loadRwithRindex: index + offset]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaryInEnvironment: envIndex atPut: index
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaryInStackAt: index
		| start |
	start := self pushesEnvironments
					 ifTrue: [ -3 ]
					 ifFalse: [ -1 ].
		^ assembler loadRwithFPindex: start - index .

! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaryInStackAtPut: index
			| start |
	start := self pushesEnvironments
						 ifTrue: [ -3 ]
						 ifFalse: [ -1 ].
			assembler storeRinFPindex: start - index

! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
trueLiteral
	assembler loadRwithTrue
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitAssignment: anSAssignment
	anSAssignment expression acceptVisitor: self.
	anSAssignment assignees do: [ :a | 
		a binding assign: nil within: self ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitBlock: anSBlock
	anSBlock isInlined
		ifTrue: [ ^ anSBlock statements do: [ :s | s acceptVisitor: self ] ].
	remainingBlocks add: anSBlock.
	self captureClosure: anSBlock 
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitCascade: anSCascade
	| receiver index |
	receiver := anSCascade receiver.
	receiver acceptVisitor: self.
	index := self pushR.
	anSCascade messages
		do: [ :m | self visitCascadeMessage: m receiver: index super: receiver isSuper ].
	self dropTos
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitCascadeMessage: anSCascadeMessage receiver: index super: aBoolean
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitIdentifier: anSIdentifier
	anSIdentifier binding valueWithin: self
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitInlinedMessage: anSMessage
	| nativizer |
	nativizer := InlinedMessageNativizer new
		message: anSMessage;
		assembler: ir;
		nativizer: self.
	nativizer inlineMessage
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitLiteral: anSLiteral
	| value |
	value := anSLiteral value.
	value isSmallInteger
		ifTrue: [ assembler loadRwithSmallInteger: value ]
		ifFalse: [ self loadLiteralAt: anSLiteral index ]
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMessage: anSMessage
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMethod: anSMethod
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
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitOptimizedMessage: anSMessage
	| nativizer |
	nativizer := BinaryMessageNativizer new
		message: anSMessage;
		assembler: ir;
		nativizer: self.
	nativizer inlineMessage
! !

!TemplateJIT methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitReturn: anSReturn
  anSReturn expression acceptVisitor: self.
  anSReturn local ifTrue: [ self emitEpilogue ] ifFalse: [ assembler
		   pushR;
		   loadRwithE.
		self emitSend: #_return: ] 
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TemplateJIT class' category: #Nativization!
TemplateJIT class
	instanceVariableNames: ''!


TemplateJIT initialize!

