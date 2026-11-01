Class {
	#name : #LookupNativizer,
	#superclass : #Object,
	#instVars : [
		'nativizer',
		'methods',
		'originals'
	],
	#category : #'Powerlang-Core-Building'
}

{ #category : #'as yet unclassified' }
LookupNativizer >> closureMethods [
	^ self selectorLookupMethods , self globalLookupMethods
		, self otherLookupMethods , self class module undermethods
		, self sendSiteMethods
]

{ #category : #'as yet unclassified' }
LookupNativizer >> globalLookupMethods [
	| result rejected global |
	result := OrderedCollection new.
	result
		add: (self method: #_cachedLookup: of: LMRProtoObject);
		add: (self method: #_cachedLookup:in: of: LMRProtoObject);
		add: (self method: #currentGlobalLookup of: Thread class);
		add: (self method: #current of: GlobalDispatchCache class).
	rejected := #(initialize flushAll: flush:forSpecies: flush:for: flush:for:startingAt:).
	global := GlobalDispatchCache methodDictionary values
		reject: [ :m | rejected includes: m selector ].
	^ result
		addAll: global;
		yourself
]

{ #category : #accessing }
LookupNativizer >> methodFor: selector [
	^methods
		detect: [:m | m selector == selector]
		ifNone: [self error: 'methodFor: not found ' , selector printString]
]

{ #category : #accessing }
LookupNativizer >> method: aSymbol of: aSpecies [
	^(aSpecies >> aSymbol)
		ifNil: [self error: 'the lookup needs ' , aSpecies name , '>>' , aSymbol]
]

{ #category : #accessing }
LookupNativizer >> methods [
	^methods
]

{ #category : #accessing }
LookupNativizer >> originals [
	^originals
]

{ #category : #accessing }
LookupNativizer >> initializeMethods [
	originals := self closureMethods.
	methods := originals collect: [:m | m copy]
]

{ #category : #accessing }
LookupNativizer >> nativizeMethods [
	| environment |
	self initializeMethods.
	environment := self newNativizationEnvironment.
	methods do: [:m | environment nativize: m]
]

{ #category : #accessing }
LookupNativizer >> nativizer: aNativizationEnvironment [
	nativizer := aNativizationEnvironment
]

{ #category : #'instance creation' }
LookupNativizer >> newNativizationEnvironment [
	| environment ignored lookup invoke lmr |
	environment := NativizationEnvironment new
		platform: nativizer platform;
		optimizedMethods: nativizer optimizedMethods.
	ignored := HaltingSend new
		filter: #(< <= = > + - * // bitAnd: bitOr: bitXor:).
	lmr := SendSite module.
	lookup := LookupLinker new initializeFrom: lmr.
	invoke := InvokeLinker new
		invoker: lmr invokeStub;
		addMethods: originals.
	^ environment
		addLinker: invoke;
		addLinker: ignored;
		addLinker: lookup;
		completeInitialization
]

{ #category : #'as yet unclassified' }
LookupNativizer >> otherLookupMethods [
	^ OrderedCollection new
		add: (self method: #objectAtValid:put: of: ProtoObject);
		add: (self method: #!== of: ProtoObject);
		add: (self method: #behavior of: LMRProtoObject);
		add: (self method: #hasInstanceBehavior of: Object);
		add: (self method: #isInstanceBehavior of: Behavior);
		add: (self method: #hasBeenFlushed of: CompiledMethod);
		add: (self method: #micStub of: LMRModule);
		add: (self method: #picStub of: LMRModule);
		add: (self method: #prepareForExecution of: CompiledMethod);
		add: (self method: #isNativized of: CompiledMethod);
		add: (self method: #optimizedCode of: CompiledMethod);
		add: (self method: #selector of: CompiledMethod);
		add: (self method: #code of: NativeCode);
		add: (self method: #compiledCode of: NativeCode);
		add: (self method: #instanceBehavior of: Species);
		add: (self method: #wantsToStepInto of: Process);
		yourself
]

{ #category : #'as yet unclassified' }
LookupNativizer >> selectorLookupMethods [
	^ OrderedCollection new
		add: (self method: #_lookup: of: LMRProtoObject);
		add: (self method: #_lookup:in: of: LMRProtoObject);
		add: (self method: #_lookup:inDictionary: of: LMRProtoObject);
		yourself
]

{ #category : #'as yet unclassified' }
LookupNativizer >> sendSiteMethods [
	| sendsite |
	^ #(_dispatchOn: _dispatchOn:startingAt: _dispatchDebuggableOn: _dispatchDebuggableOn:startingAt: sentSelector when:use: beInvoke:using: bePolymorphic isStaticSend monomorphicMap:to: monomorphicStub polymorphicMap:to: polymorphicStub maxSize reset takeNextFreeMIC takeNextFreePIC)
		collect: [ :s | self method: s of: SendSite ]
]
