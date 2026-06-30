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
		add: ProtoObject >> #_cachedLookup:;
		add: ProtoObject >> #_cachedLookup:in:;
		add: Thread class >> #currentGlobalLookup;
		add: GlobalDispatchCache class >> #current.
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
LookupNativizer >> methods [
	^methods
]

{ #category : #accessing }
LookupNativizer >> originals [
	^originals
]

{ #category : #accessing }
LookupNativizer >> initializeMethods [
	originals := self closureMethods select: [:m | m notNil].
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
		add: ProtoObject >> #objectAtValid:put:;
		add: ProtoObject >> #behavior;
		add: CompiledMethod >> #prepareForExecution;
		add: CompiledMethod >> #isNativized;
		add: CompiledMethod >> #validNativeCodeAddress;
		add: CompiledMethod >> #nativeCode;
		add: CompiledMethod >> #selector;
		add: NativeCode >> #code;
		add: NativeCode >> #compiledCode;
		add: Species >> #instanceBehavior;
		add: Process >> #wantsToStepInto;
		yourself
]

{ #category : #'as yet unclassified' }
LookupNativizer >> selectorLookupMethods [
	^ OrderedCollection new
		add: SendSite >> #_lookup:;
		add: SendSite >> #_lookup:in:;
		add: SendSite >> #_lookup:inDictionary:;
		yourself
]

{ #category : #'as yet unclassified' }
LookupNativizer >> sendSiteMethods [
	| sendsite |
	^ #(_dispatchOn: _dispatchOn:startingAt: _dispatchDebuggableOn: _dispatchDebuggableOn:startingAt: sentSelector when:use: beInvoke:using: bePolymorphic isStaticSend monomorphicMap:to: polymorphicMap:to: maxSize reset takeNextFreeMIC takeNextFreePIC)
		collect: [ :s | SendSite >> s ]
]
