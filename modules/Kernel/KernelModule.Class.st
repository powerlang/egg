'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #KernelModule category: #Kernel!
Module subclass: #KernelModule
	instanceVariableNames: 'memory entrypoint loadedModules moduleLoaders host CRITICAL unhandledErrorHandler session properties utf8 utf16 utf32'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!KernelModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Quorum Software.
    Copyright (c) 2020, LabWare.
    See (MIT) license in root directory.
!

!KernelModule methodsFor:  'snapshotting' stamp: 'KenD 28/Jun/2026 13:27:38'!
prepareForSnapshot: aBuilder
	| dict loaders |
	dict := Dictionary new.
	dict at: #Kernel put: self.
	loaders := OrderedCollection new.
	loaders add: moduleLoaders first.
	aBuilder
		addNilToken;
		map: loadedModules to: dict;
		map: moduleLoaders to: loaders
! !

!KernelModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:38'!
bootstrap
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
! !

!KernelModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
addModuleLoader: aModuleLoader
	moduleLoaders add: aModuleLoader
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
critical: aBlock
	"critical meaning is: run without GC and without interrupts. On unhandled errors, don't
	try to halt this process and continue with others, just freeze this OS process or exit."
	prev := CRITICAL.
	CRITICAL := true.
	result := aBlock value.
	CRITICAL := prev.
	aBlock value
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
ensurePropertyTableFor: anObject
	^properties at: anObject ifAbsentPut: [IdentityDictionary new]
! !

!KernelModule methodsFor:  'startup/shutdown' stamp: 'KenD 28/Jun/2026 13:27:38'!
ephemeronsDo: aBlock
	session ephemeronsDo: aBlock.
	properties ephemeronsDo: aBlock
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
exit
	host exit: 0
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
finalizer
	^session finalizer
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
freezeOnUnhandledExceptions
	unhandledErrorHandler := [:exception | self _halt]
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
host
	^host
! !

!KernelModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
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

! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
properties
	^properties
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
propertiesFor: anObject
	^properties at: anObject ifAbsent: nil
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
readFile: filename
	^host readFile: filename
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
writeFile: aFilename contents: aString
	^host writeFile: aFilename contents: aString
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
createDirectory: aString
	^host createDirectory: aString
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
pathExists: aString
	^host pathExists: aString
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
currentDirectory
	^host currentDirectory
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
getEnv: aString
	^host getEnv: aString
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
loadModuleFromPath: aString
	^host loadModuleFromPath: aString
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
load: aSymbol
	| filename |
	loadedModules at: aSymbol ifPresent: [:module | ^module].
	moduleLoaders do: [:loader | 
		(loader load: aSymbol) ifNotNil: [:module | 
			loadedModules at: aSymbol put: module.
			^module]].
	^self error: 'module not found'
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
loadedModules
	^loadedModules
! !

!KernelModule methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
loadedModuleNamed: aSymbol
	^loadedModules at: aSymbol ifAbsent: []
! !

!KernelModule methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:38'!
log: aString
	^host log: aString level: 2
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
memory
	^memory
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
prepareForExecution: aCompiledMethod
	self errorVMSpecific
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
processor
	^Processor
! !

!KernelModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
rehashWeakRegistries
	session rehashWeakRegistries.
	properties rehash
! !

!KernelModule methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeKey: aSymbol from: aMethodDictionary ifAbsent: aBlock
	| cm |
	cm := aMethodDictionary at: aSymbol ifAbsent: [^aBlock value].
	^aMethodDictionary basicRemoveKey: aSymbol asSymbol ifAbsent: aBlock
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
suspendOnUnhandledExceptions
	unhandledErrorHandler := [:exception | self suspendBecause: exception]
! !

!KernelModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
suspendBecause: anException
	| active process |
	active := Processor activeProcess.
	process := Process sending: #suspended:because: to: host with: {active. anException}.
	process takeControl
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
terminateOnUnhandledExceptions
	unhandledErrorHandler := [:exception | self terminateSessionBecause: exception description]
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
terminateSessionBecause: aString
	host logError: aString; logError: Processor activeProcess backtrace; exit: -1
! !

!KernelModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
unhandledException: anException
	| debuggable |
	CRITICAL ifTrue: [self _error: 'process failed in a critical moment'].
	unhandledErrorHandler value: anException
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
unhandledExceptionHandler: aClosure
	unhandledErrorHandler := aClosure
! !

!KernelModule methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:38'!
useHostModuleLoader
	host setupDefaultSearchPaths.
	self addModuleLoader: host.
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf8
	^utf8
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf16
	^utf16
! !

!KernelModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf32
	^utf32
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'KernelModule class' category: #Kernel!
KernelModule class
	instanceVariableNames: ''!


KernelModule initialize!

