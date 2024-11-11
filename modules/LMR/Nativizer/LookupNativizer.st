Class {
	#name : #LookupNativizer,
	#superclass : #Object,
	#instVars : [
		'nativizer',
		'methods'
	],
	#category : #'Powerlang-Core-Building'
}

{ #category : #'as yet unclassified' }
LookupNativizer >> closureMethods [
	^ self selectorLookupMethods , self globalLookupMethods
		, self otherLookupMethods , nativizer class undermethods
		, self sendSiteMethods
]

{ #category : #'as yet unclassified' }
LookupNativizer >> globalLookupMethods [
	| result out global |
	result := OrderedCollection new.
	result
		add: ProtoObject >> #_cachedLookup:;
		add: ProtoObject >> #_cachedLookup:in:;
		add: Thread metaclass >> #currentGlobalLookup;
		add: GlobalDispatchCache metaclass >> #current.
	out := #(initialize flushAll: flush:forSpecies: flush:for: flush:for:startingAt:).
	global := GlobalDispatchCache methods
		reject: [ :m | out includes: m selector ].
	^ result
		addAll: global;
		yourself
]

{ #category : #accessing }
LookupNativizer >> methodFor: selector [
	^methods detect: [:m | m selector == selector].

]

{ #category : #accessing }
LookupNativizer >> methods [
	^methods
]

{ #category : #accessing }
LookupNativizer >> nativizeMethods [
	| environment | 
	methods := self closureMethods collect: [:m | nativizer compile: m ].
	environment := self newNativizationEnvironment.
	methods do: [:m | environment nativize: m]
]

{ #category : #accessing }
LookupNativizer >> nativizer: aNativizationEnvironment [
	nativizer := aNativizationEnvironment
]

{ #category : #'instance creation' }
LookupNativizer >> newNativizationEnvironment [
	| environment ignored lookup invoke |
	environment := NativizationEnvironment new 
		platform: nativizer platform;
		globals: nativizer globals;
		optimizedMethods: nativizer optimizedMethods.
	ignored := HaltingSend new
		filter: #(< <= = > + - * // bitAnd: bitOr: bitXor:).
	lookup := LookupLinker new initializeFrom: environment.
	lookup
		filter:
			#(debuggableCopy acquireReferences nativize refreshBlocks doesNotUnderstandSelector: mustBeBoolean class allocateMoreCaches).
	invoke := InvokeLinker new
		invoker: environment invokeStub;
		addMethods: methods.
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
