'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #LookupNativizer category: #'Powerlang-Core-Building'!
Object subclass: #LookupNativizer
	instanceVariableNames: 'nativizer methods'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Building'!
!LookupNativizer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
closureMethods
	^ self selectorLookupMethods , self globalLookupMethods
		, self otherLookupMethods , nativizer class undermethods
		, self sendSiteMethods
! !

!LookupNativizer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
globalLookupMethods
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
! !

!LookupNativizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodFor: selector
	^methods detect: [:m | m selector == selector].

! !

!LookupNativizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
methods
	^methods
! !

!LookupNativizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeMethods
	| environment | 
	methods := self closureMethods collect: [:m | nativizer compile: m ].
	environment := self newNativizationEnvironment.
	methods do: [:m | environment nativize: m]
! !

!LookupNativizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizer: aNativizationEnvironment
	nativizer := aNativizationEnvironment
! !

!LookupNativizer methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
newNativizationEnvironment
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
! !

!LookupNativizer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
otherLookupMethods
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
! !

!LookupNativizer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
selectorLookupMethods
	^ OrderedCollection new
		add: SendSite >> #_lookup:;
		add: SendSite >> #_lookup:in:;
		add: SendSite >> #_lookup:inDictionary:;
		yourself
! !

!LookupNativizer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
sendSiteMethods
	| sendsite |
	^ #(_dispatchOn: _dispatchOn:startingAt: _dispatchDebuggableOn: _dispatchDebuggableOn:startingAt: sentSelector when:use: beInvoke:using: bePolymorphic isStaticSend monomorphicMap:to: polymorphicMap:to: maxSize reset takeNextFreeMIC takeNextFreePIC)
		collect: [ :s | SendSite >> s ]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LookupNativizer class' category: #'Powerlang-Core-Building'!
LookupNativizer class
	instanceVariableNames: ''!


