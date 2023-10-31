Class {
	#name : #BootstrapModule,
	#superclass : #Module,
	#instVars : [
		'environment'
	],
	#category : #'Powerlang-Core-LMR'
}

{ #category : #bootstrapping }
BootstrapModule >> bootstrapLMR [
	SendSite initializeFormatFlags.
	ProtoObject initializeConstants; initializeBitMasks.
	GlobalDispatchCache initialize.
	self initializeMemory.

	"self bootstrapNativizationEnvi	ronment"
]

{ #category : #bootstrapping }
BootstrapModule >> bootstrapNativizationEnvironment [
	bootstrapper
		nativizeInvoke;
		nativizeWriteBarrier;
		nativizeLookup
]

{ #category : #bootstrapping }
BootstrapModule >> requires [
	"
		we should require more stuff, but for know we'll be happy if we can just write a
		Kernel segment without native code. ^#(Files Tonel Nativizer Compiler ImageSegments)
	"
	^#(ImageSegments)
]

{ #category : #bootstrapping }
BootstrapModule >> builtModules [
	"
		same comment than #neededModules.	^{Kernel. Files. Tonel. Nativizer. Compiler}
	"
	^{Kernel}
]

{ #category : #bootstrapping }
BootstrapModule >> loadRequiredModules [
	"
		normally required modules are automatically loaded, but that
		doesn't happen for the bootstrapper
	"
	Kernel addModuleLoader: ModuleLoader new.
	super loadRequiredModules
]

{ #category : #bootstrapping }
BootstrapModule >> nativizeSegmentsFor: platformName [
	platform := Platform named: platformName.
	self builtModules do: [:module |
		Nativizer nativize: module for: platform]
]

{ #category : #bootstrapping }
BootstrapModule >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment
]

{ #category : #bootstrapping }
BootstrapModule >> initializeGlobals [
	| items |
	environment globalNamed: #SmallIntegerBehavior put: SmallInteger instanceBehavior.
	items := Dictionary newFromPairs: {
		#Lookup .           (NativeCode new code: 'Lookup Placeholder').
		#LookupSuper .      (NativeCode new code: 'LookupSuper Placeholder').
		#DebuggableLookup . (NativeCode new code: 'DebuggableLookup placeholder').
		#DebuggableLookupSuper. (NativeCode new code: 'DebuggableLookupSuper placholder').
		#Invoke .           (NativeCode new code: 'Invoke placeholder').
		#Safepoint .        (NativeCode new code: 'SafepointCheck placeholder').
		#WriteBarrier .     (NativeCode new code: 'Write Barrier placeholder')}.
	items
		keysAndValuesDo: [ :key :placeholder | environment globalNamed: key put: placeholder ]
]

{ #category : #initialization }
BootstrapModule >> initializeMemory [
	| kernel rs |
	kernel := GCSpace new.
	rs := CriticalArray on: (Array new: 16 * 1024).
	memory := Memory new
		addSpace: kernel;
		fromSpace: kernel;
		eden: kernel;
		rememberedSet: rs.
]

{ #category : #private }
BootstrapModule >> mapGlobal: aSymbol to: nativeCode [
	placeholder := environment globalNamed: aSymbol.
	placeholder code become: nativeCode code.
	placeholder become: nativeCode.
	Kernel namespace at: aSymbol put: nativeCode
]

{ #category : #bootstrapping }
BootstrapModule >> nativizeInvoke [
	| invoke |
	invoke := SendSite >> #_invokeOn:.
	environment 
		nativizeOptimizing: invoke;
		mapGlobal: #Invoke to: invoke
]

{ #category : #bootstrapping }
BootstrapModule >> nativizeLookup [
	| nativizer lookup lookupSuper |
	nativizer := LookupNativizer new
		bootstrapper: environment;
		nativizeMethods.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	environment
		mapGlobal: #Lookup to: lookup nativeCode;
		mapGlobal: #LookupSuper to: lookupSuper nativeCode
]

{ #category : #bootstrapping }
BootstrapModule >> nativizeWriteBarrier [
	| map inlined dispatcher barrier |
	map := {
		(Memory class -> #(current)).
		(Memory -> #(isYoung: isYoungSafe: remember:)).
		(CriticalArray -> #(unsafeAdd: #unsafeAt:put:)).
		(Magnitude -> #(#between:and:))
	}.
	inlined := NativizationEnvironment methodSubset: map.
	inlined addAll: self class undermethods.
	barrier := ProtoObject >> #holdRefererIfNeeded:.
	dispatcher := LookupLinker new initializeFrom: nativizer.
	(Module forTarget: target)
		globals: nativizer globals;
		inlinedMethods: inlined;
		messageLinker: dispatcher;
		completeInitialization;
		nativizeOptimizing: barrier.
	self mapGlobal: #WriteBarrier to: barrier nativeCode
]

{ #category : #bootstrapping }
BootstrapModule >> writeModules [
	self builtModules do: [:module |
		ImageSegments.Builder new module: module; build]
]

