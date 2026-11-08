"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessVMStack,
	#superclass : #ProcessStack,
	#instVars : [
		'buffer',
		'bufferSize'
	],
	#category : #Kernel
}

{ #category : 'instance creation' }
ProcessVMStack class >> on: aProcess [
	^self new process: aProcess
]

{ #category : 'Primitives' }
ProcessVMStack >> at: anInteger [
	<primitive: ProcessVMStackAt>
]

{ #category : 'Primitives' }
ProcessVMStack >> at: anInteger put: anObject [
	<primitive: ProcessVMStackAtPut>
]

{ #category : 'Primitives' }
ProcessVMStack >> initializeWithNewBuffer [
	<primitive: ProcessVMStackInitializeWithNewBuffer>
]

{ #category : 'Primitives' }
ProcessVMStack >> initializeWithActiveBuffer [
	<primitive: ProcessVMStackInitializeWithActiveBuffer>
]

{ #category : 'Primitives' }
ProcessVMStack >> bpAt: anInteger [
	<primitive: ProcessVMStackBpAt>
]

{ #category : 'Primitives' }
ProcessVMStack >> bpAt: anInteger put: anotherInteger [
	<primitive: ProcessVMStackBpAtPut>
]

{ #category : 'Primitives' }
ProcessVMStack >> bufferSize [
	<primitive: ProcessVMStackBufferSize>
]

{ #category : 'Primitives' }
ProcessVMStack >> contextSwitchTo: aProcessStack [
	<primitive: ProcessVMStackContextSwitchTo>
]

{ #category : 'accessing' }
ProcessVMStack >> process: aProcess [
	super process: aProcess.
	aProcess isActive
		ifTrue: [self initializeWithActiveBuffer]
		ifFalse: [self initializeWithNewBuffer]
]

{ #category : 'Primitives' }
ProcessVMStack >> pcAt: anInteger [
	<primitive: ProcessVMStackPcAt>
]

{ #category : 'Primitives' }
ProcessVMStack >> pcAt: anInteger put: anotherInteger of: code[
	<primitive: ProcessVMStackPcAtPut>
]

{ #category : #primitives }
ProcessVMStack >> snapshot [
	<primitive: ProcessVMStackSnapshot>
]

{ #category : #primitives }
ProcessVMStack >> sp: anInteger [
	<primitive: ProcessVMStackSPPut>
]

{ #category : #reifying }
ProcessVMStack >> reify [
	^Context fromStack: self
]

{ #category : #initialization }
ProcessVMStack class >> initializeConstants [
	self addNamespaceAs: #FrameOffsets.
	FrameOffsets
		at: #ReceiverOffset put: 1;
		at: #CodeOffset put: 2;
		at: #EnvironmentOffset put: 4;
		at: #FirstTempOffset put: 5;
		at: #ReturnPcOffset put: 1;
		at: #CallerTopOffset put: 2
]

{ #category : #reifying }
ProcessVMStack >> receiverAt: frame [
	^self at: frame - ReceiverOffset
]

{ #category : #reifying }
ProcessVMStack >> codeAt: frame [
	^self at: frame - CodeOffset
]

{ #category : #reifying }
ProcessVMStack >> environmentAt: frame [
	^self at: frame - EnvironmentOffset
]

{ #category : #reifying }
ProcessVMStack >> stackAt: frame top: top [
	^self copyFrom: frame - FirstTempOffset to: top
]

{ #category : #reifying }
ProcessVMStack >> callerOf: frame [
	^self bpAt: frame
]

{ #category : #reifying }
ProcessVMStack >> returnPcAt: frame [
	^self pcAt: frame + ReturnPcOffset
]

{ #category : #reifying }
ProcessVMStack >> callerTopOf: frame [
	^frame + CallerTopOffset
]
