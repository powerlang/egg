"
    Copyright (c) 2022, Quorum Software.
    Copyright (c) 2020, LabWare.
    See (MIT) license in root directory.
"

Class {
	#name : #KernelModule,
	#superclass : #Module,
	#instVars : [
		'memory',
		'entrypoint',
		'loadedModules',
		'moduleLoaders',
		'host',
		'CRITICAL',
		'unhandledErrorHandler',
		'session',
		'properties',
		'utf8',
		'utf16',
		'utf32'
	],
	#category : #Kernel
}

{ #category : #snapshotting }
KernelModule >> prepareForSnapshot: aBuilder [
	| dict loaders |
	dict := Dictionary new.
	dict at: #Kernel put: self.
	loaders := OrderedCollection new.
	loaders add: moduleLoaders first.
	aBuilder
		addNilToken;
		map: loadedModules to: dict;
		map: moduleLoaders to: loaders
]

{ #category : #bootstrapping }
KernelModule >> bootstrap [
	| shift |
	CompiledBlock initializeFormatFlags.
	CompiledMethod initializeFormatFlags.
	Species initializeFormatFlags.
	Character initializeCharacters; initializeNamedCharacters; initializeLatin1Tables.
	Closure initializeIndexes.
	Float initializeConstants.
	HashTable initializeConstants; initializeSizes.
	HashTablePolicy initializeEmptySlot.
	HashedCollection initializePolicies.
	LargeInteger initializeBase.
	LargeNegativeInteger initializeConstants.
	SmallInteger initializeConstants.
	cachedLookups := Dictionary new.
	shift := WordSize = 8 ifTrue: [3] ifFalse: [2].
	namespace 
		at: #nil put: nil;
		at: #true put: true;
		at: #false put: false;
		at: #WordSize put: WordSize;
		at: #WordSizeShift put: shift;
		at: #Kernel put: self;
		at: #KnownSymbols put: #(+ - < > <= >= = == not);
		at: #Processor put: ProcessorScheduler new.
	StarToken initializeCurrent.
	utf8 := UTF8 new.
	utf16 := UTF16 new.
	utf32 := UTF32 new.
	Symbol initializeSymbolTable.
	namespace at: #SymbolTable put: Symbol symbolTable.
	Stream initializePools.
	CharacterArray initializePools.
	ProtoObject initializeConstants; initializeBitMasks.

	#FFICall. "hack to have this symbol (used by primitiveFFICall) in kernel ims"
	self initialize.
	CRITICAL := false.
	self suspendOnUnhandledExceptions
]

{ #category : #initialization }
KernelModule >> addModuleLoader: aModuleLoader [
	moduleLoaders add: aModuleLoader
]

{ #category : #services }
KernelModule >> critical: aBlock [
	"critical meaning is: run without GC and without interrupts. On unhandled errors, don't
	try to halt this process and continue with others, just freeze this OS process or exit."
	prev := CRITICAL.
	CRITICAL := true.
	result := aBlock value.
	CRITICAL := prev.
	aBlock value
]

{ #category : #accessing }
KernelModule >> ensurePropertyTableFor: anObject [
	^properties at: anObject ifAbsentPut: [IdentityDictionary new]
]

{ #category : #'startup/shutdown' }
KernelModule >> ephemeronsDo: aBlock [
	session ephemeronsDo: aBlock.
	properties ephemeronsDo: aBlock
]

{ #category : #accessing }
KernelModule >> exit [
	host exit: 0
]

{ #category : #accessing }
KernelModule >> finalizer [
	^session finalizer
]

{ #category : #services }
KernelModule >> freezeOnUnhandledExceptions [
	unhandledErrorHandler := [:exception | self _halt]
]

{ #category : #accessing }
KernelModule >> host [
	^host
]

{ #category : #initialization }
KernelModule >> initialize [
	"
		We cannot use addClass: because it creates new symbol instances, which must be
		avoided during bootstrap (else we would end with duplicated symbols)
	"
	self basicInitialize; freezeOnUnhandledExceptions.
	host := HostSystem new.
	moduleLoaders := OrderedCollection new.
	loadedModules := Dictionary new.
	loadedModules at: #Kernel put: self.
	namespace 
		keys do: [:symbol | | obj |
			obj := namespace at: symbol.
			obj isClass ifTrue: [classes add: obj].
			exports add: symbol].
	session := SmalltalkSession new.
	properties := WeakIdentityDictionary new.

]

{ #category : #accessing }
KernelModule >> properties [
	^properties
]

{ #category : #accessing }
KernelModule >> propertiesFor: anObject [
	^properties at: anObject ifAbsent: nil
]

{ #category : #services }
KernelModule >> readFile: filename [
	^host readFile: filename
]

{ #category : #services }
KernelModule >> load: aSymbol [
	| filename |
	loadedModules at: aSymbol ifPresent: [:module | ^module].
	moduleLoaders do: [:loader | 
		(loader load: aSymbol) ifNotNil: [:module | 
			loadedModules at: aSymbol put: module.
			^module]].
	^self error: 'module not found'
]

{ #category : #accessing }
KernelModule >> loadedModules [
	^loadedModules
]

{ #category : #inquiries }
KernelModule >> loadedModuleNamed: aSymbol [
	^loadedModules at: aSymbol ifAbsent: []
]

{ #category : #logging }
KernelModule >> log: aString [
	^host log: aString level: 2
]

{ #category : #accessing }
KernelModule >> memory [
	^memory
]

{ #category : #services }
KernelModule >> prepareForExecution: aCompiledMethod [
	self errorVMSpecific
]

{ #category : #accessing }
KernelModule >> processor [
	^Processor
]

{ #category : #initialization }
KernelModule >> rehashWeakRegistries [
	session rehashWeakRegistries.
	properties rehash
]

{ #category : #removing }
KernelModule >> removeKey: aSymbol from: aMethodDictionary ifAbsent: aBlock [
	| cm |
	cm := aMethodDictionary at: aSymbol ifAbsent: [^aBlock value].
	^aMethodDictionary basicRemoveKey: aSymbol asSymbol ifAbsent: aBlock
]

{ #category : #services }
KernelModule >> suspendOnUnhandledExceptions [
	unhandledErrorHandler := [:exception | self suspendBecause: exception]
]

{ #category : #private }
KernelModule >> suspendBecause: anException [
	| active process |
	active := Processor activeProcess.
	"active snapshot ifNil: [^self]."
	process := Process sending: #suspended:because: to: host with: {active. anException}.
	process takeControl
]

{ #category : #services }
KernelModule >> terminateOnUnhandledExceptions [
	unhandledErrorHandler := [:exception | self terminateSessionBecause: exception description]
]

{ #category : #services }
KernelModule >> terminateSessionBecause: aString [
	host logError: aString; logError: Processor activeProcess backtrace; exit: -1
]

{ #category : #services }
KernelModule >> unhandledException: anException [
	| debuggable |
	CRITICAL ifTrue: [self _error: 'process failed in a critical moment'].
	unhandledErrorHandler value: anException
]

{ #category : #accessing }
KernelModule >> unhandledExceptionHandler: aClosure [
	unhandledErrorHandler := aClosure
]

{ #category : #loading }
KernelModule >> useHostModuleLoader [
	self addModuleLoader: host.
]

{ #category : #accessing }
KernelModule >> utf8 [
	^utf8
]

{ #category : #accessing }
KernelModule >> utf16 [
	^utf16
]

{ #category : #accessing }
KernelModule >> utf32 [
	^utf32
]
