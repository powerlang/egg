Class {
	#name : #LMRModule,
	#superclass : #Module,
	#instVars : [
		'globals',
		'memory',
		'micStub',
		'picStub',
		'nativizerBlock'
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
	globals at: index put: anObject
]

{ #category : #accessing }
LMRModule >> globals [
	^globals
]

{ #category : #spec }
LMRModule >> imports [
	^{
		#Kernel -> #(ProcessStack ProtoObject SequenceableCollection WordSize Processor).
		#'Kernel.LMR' -> #(LMRProtoObject)
	}
] 

{ #category : #accessing }
LMRModule >> globals: anArray [
	globals := anArray
]

{ #category : #snapshotting }
LMRModule >> requiresNativization [
	^false
]

{ #category : #snapshotting }
LMRModule >> nativizerBlock [
	^nativizerBlock
]

{ #category : #snapshotting }
LMRModule >> nativizerBlock: aBlock [
	nativizerBlock := aBlock
]

{ #category : #accessing }
LMRModule >> micStub [
	^micStub
]

{ #category : #accessing }
LMRModule >> micStub: aByteArray [
	micStub := aByteArray
]

{ #category : #accessing }
LMRModule >> picStub [
	^picStub
]

{ #category : #accessing }
LMRModule >> picStub: aByteArray [
	picStub := aByteArray
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
	namespace at: #CRITICAL put: false.
	SendSite initializeFormatFlags.
	GlobalDispatchCache initialize.
	self initializeMemory.
	LMRProtoObject module namespace
		at: #Memory put: Memory;
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
