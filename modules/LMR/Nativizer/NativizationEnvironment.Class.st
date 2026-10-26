'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #NativizationEnvironment category: #Nativization!
Object subclass: #NativizationEnvironment
	instanceVariableNames: 'platform optimizedMethods invokedMethods inlinedMethods messageLinker writeBarrier safepointCheck cachedNativizer busy'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
abi
	^platform abi
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
addLinker: aLinker
	messageLinker add: aLinker
! !

!NativizationEnvironment methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
completeInitialization
	cachedNativizer := self newTemplateJIT 
! !

!NativizationEnvironment methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	busy := false.
	optimizedMethods := OrderedCollection new.
	invokedMethods := OrderedCollection new.
	inlinedMethods := OrderedCollection new.
	messageLinker := CompositeMessageLinker new.
	messageLinker add: InlineMessageLinker new.
! !

!NativizationEnvironment methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeLinkersFor: anLMRModule
	| invoker dispatcher |
	invoker := InvokeLinker new invoker: anLMRModule invokeStub; addMethods: invokedMethods.
	dispatcher := LookupLinker new initializeFrom: anLMRModule.
	self
		addLinker: invoker;
		addLinker: dispatcher;
		completeInitialization
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlinedMethods
	^inlinedMethods
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlinedMethods: aCollection
	inlinedMethods := aCollection
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
invokedMethods
	^invokedMethods
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
invokedMethods: aCollection
	invokedMethods := aCollection asOrderedCollection 
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
messageLinker
	^messageLinker
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
messageLinker: aLinker
	messageLinker := aLinker 
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodNativizer
	^cachedNativizer
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativize: aCompiledMethod
	^(self shouldOptimize: aCompiledMethod)
		  ifTrue: [ self nativizeOptimizing: aCompiledMethod ]
		  ifFalse: [ self nativizeWithoutOptimizing: aCompiledMethod ] 
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeOptimizing: aCompiledMethod
	self optimizingNativizer
		method: aCompiledMethod;
		nativize
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizerDuring: aBlock
	^busy
		  ifFalse: [ 
			  busy := true.
			  [ aBlock value: cachedNativizer ] ensure: [ busy := false ] ]
		  ifTrue: [ 
			  | old |
			  old := cachedNativizer. 
			  [ 
			  cachedNativizer := self newTemplateJIT.
			  aBlock value: cachedNativizer ] ensure: [ cachedNativizer := old ] ]
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeWithoutOptimizing: aCompiledMethod
	| method |
	method := self
		nativizerDuring: [ :jit | jit nativize: aCompiledMethod ].
	^method
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
newAssembler
	^platform newAssembler
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
newTemplateJIT
	^TemplateJIT new environment: self
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
optimizedMethods
	^optimizedMethods
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
optimizedMethods: aCollection
	optimizedMethods := aCollection
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
optimizingNativizer
	^OptimizingNativizer new environment: self
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
platform
	^platform
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
platform: aNativizationPlatform
	platform := aNativizationPlatform
! !

!NativizationEnvironment methodsFor:  'printing & storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	"append a printed representation of the receiver to the argument, aStream"

	super printOn: aStream.
	aStream nextPutAll: '(platform: '.
	platform name printOn: aStream.
	aStream nextPut: $)
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
safepointCheck: anObject
	safepointCheck := anObject 
! !

!NativizationEnvironment methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
sexpressionOffsetsOf: code
	| method |
	method := code method.
	(self shouldOptimize: method) ifTrue: [ ^#(  ) ].
	^self nativizerDuring: [ :nativizer |
		  method nativeCode ifNotNil: [ method := method copy ].
		  nativizer compile: method.
		  nativizer sexpressionOffsetsOf: code ]
! !

!NativizationEnvironment methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:40'!
shouldInline: aSymbol
	^inlinedMethods anySatisfy: [ :m | m selector = aSymbol ]
! !

!NativizationEnvironment methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:40'!
shouldOptimize: method
	| selector classname |
	selector := method selector.
	classname := method classBinding name.
	^optimizedMethods anySatisfy: [:m | m selector = selector and: [ m classBinding name = classname ]  ]
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize
	^self abi wordSize
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSizeShift
	^self abi wordSizeShift
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeBarrier
	^writeBarrier
! !

!NativizationEnvironment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeBarrier: aCompiledMethod
	writeBarrier := aCompiledMethod.
	invokedMethods add: writeBarrier 
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativizationEnvironment class' category: #Nativization!
NativizationEnvironment class
	instanceVariableNames: ''!


NativizationEnvironment initialize!

