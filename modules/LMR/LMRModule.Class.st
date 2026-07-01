'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #LMRModule category: #'Powerlang-Core-LMR'!
Module subclass: #LMRModule
	instanceVariableNames: 'globals memory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-LMR'!
!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
globalNamed: aSymbol
	| index |
	index := self class indexOfGlobal: aSymbol.
	^globals at: index
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
globalNamed: aSymbol put: anObject
	| index |
	index := self class indexOfGlobal: aSymbol.
	globals at: index put: anObject
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
globals
	^globals
! !

!LMRModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#Kernel -> #(ProcessStack ProtoObject SequenceableCollection WordSize).
		#Kernel.LMR -> #(LMRProtoObject)
	}
! !

!LMRModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeGlobalsWithStubs
	| items |
	globals := Array new: self class globalNames size.

	self globalNamed: #SmallIntegerBehavior put: SmallInteger instanceBehavior.

	items := Dictionary withAll: {
		#Lookup                -> (NativeCode new code: 'Lookup Placeholder').
		#LookupSuper           -> (NativeCode new code: 'LookupSuper Placeholder').
		#DebuggableLookup      -> (NativeCode new code: 'DebuggableLookup placeholder').
		#DebuggableLookupSuper -> (NativeCode new code: 'DebuggableLookupSuper placholder').
		#Invoke                -> (NativeCode new code: 'Invoke placeholder').
		#Safepoint             -> (NativeCode new code: 'SafepointCheck placeholder').
		#WriteBarrier          -> (NativeCode new code: 'Write Barrier placeholder')}.
	items
		keysAndValuesDo: [ :key :placeholder | self globalNamed: key put: placeholder ]
! !

!LMRModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeMemory
	| kernel |
	kernel := GCSpace new.
	kernel name: 'Kernel'.
	memory := Memory new
		addKernelSpace: kernel;
		fromSpace: kernel;
		eden: kernel
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
invokeStub
	^(self globalNamed: #Invoke) code
! !

!LMRModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:39'!
justLoaded
	super justLoaded.
	SendSite initializeFormatFlags.
	GlobalDispatchCache initialize.
	self
		initializeMemory;
		initializeGlobalsWithStubs.
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookup
	^self globalNamed: #Lookup
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupDebuggableStub
	^(self globalNamed: #DebuggableLookup) code
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupStub
	^(self globalNamed: #Lookup) code
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupSuper
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^globals at: index
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupSuperDebuggableStub
	| index |
	index := self class indexOfGlobal: #DebuggableLookupSuper.
	^(globals at: index) code
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupSuperStub
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^(globals at: index) code
! !

!LMRModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapGlobal: aSymbol to: nativeCode
	placeholder := self globalNamed: aSymbol.
	placeholder code become: nativeCode code.
	placeholder become: nativeCode.
! !

!LMRModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
safepoint
	^(self globalNamed: #Safepoint) code
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LMRModule class' category: #'Powerlang-Core-LMR'!
LMRModule class
	instanceVariableNames: ''!

!LMRModule class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
globalNames
	^#(Lookup LookupSuper WriteBarrier Safepoint SmallIntegerBehavior Invoke DebuggableLookup DebuggableLookupSuper)
! !

!LMRModule class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
indexOfGlobal: aSymbol
	^self globalNames
		indexOf: aSymbol
		ifAbsent: [self error: 'global not found']
! !


