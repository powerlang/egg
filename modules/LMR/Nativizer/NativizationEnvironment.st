Class {
	#name : #NativizationEnvironment,
	#superclass : #Object,
	#instVars : [
		'platform',
		'optimizedMethods',
		'invokedMethods',
		'inlinedMethods',
		'messageLinker',
		'writeBarrier',
		'safepointCheck',
		'cachedNativizer',
		'busy'
	],
	#category : #Nativization
}

{ #category : #accessing }
NativizationEnvironment >> abi [
	^platform abi
]

{ #category : #accessing }
NativizationEnvironment >> addLinker: aLinker [
	messageLinker add: aLinker
]

{ #category : #initialization }
NativizationEnvironment >> completeInitialization [
	cachedNativizer := self newTemplateJIT 
]

{ #category : #initialization }
NativizationEnvironment >> initialize [
	busy := false.
	optimizedMethods := OrderedCollection new.
	invokedMethods := OrderedCollection new.
	inlinedMethods := OrderedCollection new.
	messageLinker := CompositeMessageLinker new.
	messageLinker add: InlineMessageLinker new.
]

{ #category : #initialization }
NativizationEnvironment >> initializeLinkersFor: anLMRModule [
	| invoker dispatcher |
	invoker := InvokeLinker new invoker: anLMRModule invokeStub; addMethods: invokedMethods.
	dispatcher := LookupLinker new initializeFrom: anLMRModule.
	self
		addLinker: invoker;
		addLinker: dispatcher;
		completeInitialization
]

{ #category : #accessing }
NativizationEnvironment >> inlinedMethods [
	^inlinedMethods
]

{ #category : #accessing }
NativizationEnvironment >> inlinedMethods: aCollection [
	inlinedMethods := aCollection
]


{ #category : #accessing }
NativizationEnvironment >> invokedMethods [
	^invokedMethods
]

{ #category : #accessing }
NativizationEnvironment >> invokedMethods: aCollection [
	invokedMethods := aCollection asOrderedCollection 
]


{ #category : #accessing }
NativizationEnvironment >> messageLinker [
	^messageLinker
]

{ #category : #accessing }
NativizationEnvironment >> messageLinker: aLinker [
	messageLinker := aLinker 
]

{ #category : #accessing }
NativizationEnvironment >> methodNativizer [
	^cachedNativizer
]

{ #category : #services }
NativizationEnvironment >> nativize: aCompiledMethod [
	^(self shouldOptimize: aCompiledMethod)
		  ifTrue: [ self nativizeOptimizing: aCompiledMethod ]
		  ifFalse: [ self nativizeWithoutOptimizing: aCompiledMethod ] 
]

{ #category : #services }
NativizationEnvironment >> nativizeOptimizing: aCompiledMethod [
	self optimizingNativizer
		method: aCompiledMethod;
		nativize
]

{ #category : #services }
NativizationEnvironment >> nativizerDuring: aBlock [
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
]

{ #category : #services }
NativizationEnvironment >> nativizeWithoutOptimizing: aCompiledMethod [
	| method |
	method := self
		nativizerDuring: [ :jit | jit nativize: aCompiledMethod ].
	^method
]

{ #category : #services }
NativizationEnvironment >> newAssembler [
	^platform newAssembler
]

{ #category : #services }
NativizationEnvironment >> newTemplateJIT [
	^TemplateJIT new environment: self
]

{ #category : #accessing }
NativizationEnvironment >> optimizedMethods [
	^optimizedMethods
]

{ #category : #accessing }
NativizationEnvironment >> optimizedMethods: aCollection [
	optimizedMethods := aCollection
]

{ #category : #services }
NativizationEnvironment >> optimizingNativizer [
	^OptimizingNativizer new environment: self
]

{ #category : #accessing }
NativizationEnvironment >> platform [
	^platform
]

{ #category : #accessing }
NativizationEnvironment >> platform: aNativizationPlatform [
	platform := aNativizationPlatform
]

{ #category : #'printing & storing' }
NativizationEnvironment >> printOn: aStream [
	"append a printed representation of the receiver to the argument, aStream"

	super printOn: aStream.
	aStream nextPutAll: '(platform: '.
	platform name printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
NativizationEnvironment >> safepointCheck: anObject [
	safepointCheck := anObject 
]

{ #category : #services }
NativizationEnvironment >> sexpressionOffsetsOf: code [
	| method |
	method := code method.
	(self shouldOptimize: method) ifTrue: [ ^#(  ) ].
	^self nativizerDuring: [ :nativizer |
		  method nativeCode ifNotNil: [ method := method copy ].
		  nativizer compile: method.
		  nativizer sexpressionOffsetsOf: code ]
]

{ #category : #queries }
NativizationEnvironment >> shouldInline: aSymbol [
	^inlinedMethods anySatisfy: [ :m | m selector = aSymbol ]
]

{ #category : #queries }
NativizationEnvironment >> shouldOptimize: method [
	| selector classname |
	selector := method selector.
	classname := method classBinding name.
	^optimizedMethods anySatisfy: [:m | m selector = selector and: [ m classBinding name = classname ]  ]
]

{ #category : #accessing }
NativizationEnvironment >> wordSize [
	^self abi wordSize
]

{ #category : #accessing }
NativizationEnvironment >> wordSizeShift [
	^self abi wordSizeShift
]

{ #category : #accessing }
NativizationEnvironment >> writeBarrier [
	^writeBarrier
]

{ #category : #accessing }
NativizationEnvironment >> writeBarrier: aCompiledMethod [
	writeBarrier := aCompiledMethod.
	invokedMethods add: writeBarrier 
]
