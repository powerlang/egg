Class {
	#name : #LMRModule,
	#superclass : #Module,
	#instVars : [
		'globals',
		'memory',
		'micStub',
		'picStub'
	],
	#category : #LMR
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
LMRModule >> indexOfGlobal: aSymbol [
	^self class indexOfGlobal: aSymbol
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
	globals at: index put: anObject.
	anObject isNativeCode ifTrue: [self exportGlobal: anObject as: aSymbol]
]

{ #category : #accessing }
LMRModule >> exportGlobal: aNativeCode as: aSymbol [
	| name |
	name := ('__' , aSymbol , 'Code__') asSymbol.
	self
		exportByReference: aNativeCode as: aSymbol;
		exportByReference: aNativeCode code as: name
]

{ #category : #accessing }
LMRModule >> globals [
	^globals
]

{ #category : #spec }
LMRModule >> imports [
	^{
		#Kernel -> #(ByteArray Ephemeron IdentityDictionary IdentitySet LinkedCollection ProcessLMRStack ProcessStack ProtoObject SequenceableCollection WeakArray WeakIdentitySet WordSize WordSizeShift Processor).
		#'Kernel.LMR' -> #(LMRProtoObject)
	}
] 

{ #category : #accessing }
LMRModule >> globals: anArray [
	globals := anArray.
	self exportByReference: anArray as: #'__globals__'
]

{ #category : #accessing }
LMRModule >> memory [
	^memory
]

{ #category : #accessing }
LMRModule >> memory: aMemory [
	memory := aMemory
]

{ #category : #accessing }
LMRModule >> micStub [
	^micStub
]

{ #category : #accessing }
LMRModule >> micStub: aByteArray [
	micStub := aByteArray.
	self exportByReference: aByteArray as: #'__micStub__'
]

{ #category : #accessing }
LMRModule >> picStub [
	^picStub
]

{ #category : #accessing }
LMRModule >> picStub: aByteArray [
	picStub := aByteArray.
	self exportByReference: aByteArray as: #'__picStub__'
]

{ #category : #bootstrapping }
LMRModule >> initializeMemory [
	| kernel |
	kernel := GCSpace new.
	kernel name: 'Kernel'.
	memory := Memory new
		addKernelSpace: kernel;
		fromSpace: kernel;
		eden: kernel.
	self export: kernel as: #KernelSpace
]

{ #category : #accessing }
LMRModule >> invokeStub [
	^(self globalNamed: #Invoke) code
]

{ #category : #bootstrapping }
LMRModule >> justLoaded [
	super justLoaded.
	namespace at: #CRITICAL put: false.
	SendSite initialize.
	GlobalDispatchCache initialize.
	self initializeMemory.
	LMRProtoObject module namespace
		at: #Memory put: Memory;
		at: #GlobalDispatchCache put: GlobalDispatchCache;
		at: #SendSite put: SendSite;
		at: #StackFrameCursor put: StackFrameCursor
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
	self globalNamed: aSymbol put: nativeCode
]

{ #category : #accessing }
LMRModule >> safepoint [
	^(self globalNamed: #Safepoint) code
]
