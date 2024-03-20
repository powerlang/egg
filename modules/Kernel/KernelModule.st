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
		'CRITICAL'
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
	Character initializeCharacters; initializeNamedCharacters.
	Closure initializeIndexes.
	ExternalMemory initializeConstants.
	Float initializeConstants.
	HashTable initializeConstants; initializeSizes.
	HashTablePolicy initializeEmptySlot.
	HashedCollection initializePolicies.
	LargeInteger initializeBase.
	LargeNegativeInteger initializeConstants.
	SmallInteger initializeConstants.
	CRITICAL := true.
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
	Unicode allSubclasses do: [:c | c initializeCurrent].
	Symbol initializeSymbolTable.
	namespace at: #SymbolTable put: Symbol symbolTable.
	Stream initializePools.
	CharacterArray initializePools.
	
	self initialize
]

{ #category : #initialization }
KernelModule >> addModuleLoader: aModuleLoader [
	moduleLoaders add: aModuleLoader
]

{ #category : #services }
KernelModule >> critical: aBlock [
	"critical meaning is: run without GC and without interrupts"
	prev := CRITICAL.
	CRITICAL := true.
	result := aBlock value.
	CRITICAL := prev.
	aBlock value
]

KernelModule >> entry: argc argv: argv [
	<callback: long (long, pointer)>
	"^Smalltalk startSession"
	^KernelModule new foo.

]

{ #category : #accessing }
KernelModule >> host [
	^host
]

{ #category : #initialization }
KernelModule >> initialize [
	"
		we cannot do super initialize here, because it would
		reset our bootstrapped namespace. We cannot use addClass:
		because it creates new symbol instances, which must be
		avoided during bootstrap (else we would end with duplicated symbols)
	"
	self basicInitialize.
	host := HostSystem new.
	moduleLoaders := OrderedCollection new.
	loadedModules := Dictionary new.
	loadedModules at: #Kernel put: self.
	namespace 
		keys do: [:symbol | | obj |
			obj := namespace at: symbol.
			obj isClass ifTrue: [classes add: obj].
			exports add: symbol]
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

{ #category : #accessing }
KernelModule >> memory [
	^memory
]

{ #category : #services }
KernelModule >> prepareForExecution: aCompiledMethod [
	self errorVMSpecific
]

{ #category : #removing }
KernelModule >> removeKey: aSymbol from: aMethodDictionary ifAbsent: aBlock [
	| cm |
	cm := aMethodDictionary at: aSymbol ifAbsent: [^aBlock value].
	^aMethodDictionary basicRemoveKey: aSymbol asSelector ifAbsent: aBlock
]

{ #category : #loading }
KernelModule >> useHostModuleLoader [
	self addModuleLoader: host.
]

KernelModule >> foo [
	| result |
	"self _halt."
	"#(1 2 3 4 5) do: [:i | result := i]."
	result := 42 factorial "0x10000000000000000 * 1".
	^result = 0x3C1581D491B28F523C23ABDF35B689C908000000000 ifTrue: [1] ifFalse: [0]
]


