Class {
	#name : #LMRModule,
	#superclass : #Module,
	#instVars : [
		'globals',
		'memory'
	],
	#category : #'Powerlang-Core-LMR'
}

{ #category : #accessing }
LMRModule class >> globalNames [
	^#(Lookup LookupSuper WriteBarrier Safepoint SmallIntegerBehavior Invoke DebuggableLookup DebuggableLookupSuper)
]

{ #category : #accessing }
LMRModule class >> indexOfGlobal: aSymbol [
	^self globalNames
		indexOf: aSymbol
		ifAbsent: [self error: 'global not found']
]

{ #category : #accessing }
LMRModule >> globalNamed: aSymbol [
	| index |
	index := self class indexOfGlobal: aSymbol.
	^globals at: index
]

{ #category : #accessing }
LMRModule >> globalNamed: aSymbol put: anObject [
	| index |
	index := self class indexOfGlobal: aSymbol.
	globals at: index put: anObject
]

{ #category : #accessing }
LMRModule >> globals [
	^globals
]

{ #category : #spec }
LMRModule >> imports [
	^{
		#Kernel -> #(ProcessStack ProtoObject SequenceableCollection WordSize).
		#Kernel.LMR -> #(LMRProtoObject)
	}
] 

{ #category : #bootstrapping }
LMRModule >> initializeGlobalsWithStubs [
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
]

{ #category : #bootstrapping }
LMRModule >> initializeMemory [
	| kernel |
	kernel := GCSpace new.
	kernel name: 'Kernel'.
	memory := Memory new
		addKernelSpace: kernel;
		fromSpace: kernel;
		eden: kernel
]

{ #category : #accessing }
LMRModule >> invokeStub [
	^(self globalNamed: #Invoke) code
]

{ #category : #bootstrapping }
LMRModule >> justLoaded [
	super justLoaded.
	SendSite initializeFormatFlags.
	GlobalDispatchCache initialize.
	self
		initializeMemory;
		initializeGlobalsWithStubs.
]

{ #category : #accessing }
LMRModule >> lookup [
	^self globalNamed: #Lookup
]

{ #category : #accessing }
LMRModule >> lookupDebuggableStub [
	^(self globalNamed: #DebuggableLookup) code
]

{ #category : #accessing }
LMRModule >> lookupStub [
	^(self globalNamed: #Lookup) code
]

{ #category : #accessing }
LMRModule >> lookupSuper [
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^globals at: index
]

{ #category : #accessing }
LMRModule >> lookupSuperDebuggableStub [
	| index |
	index := self class indexOfGlobal: #DebuggableLookupSuper.
	^(globals at: index) code
]

{ #category : #accessing }
LMRModule >> lookupSuperStub [
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^(globals at: index) code
]

{ #category : #private }
LMRModule >> mapGlobal: aSymbol to: nativeCode [
	placeholder := self globalNamed: aSymbol.
	placeholder code become: nativeCode code.
	placeholder become: nativeCode.
]

{ #category : #accessing }
LMRModule >> safepoint [
	^(self globalNamed: #Safepoint) code
]
