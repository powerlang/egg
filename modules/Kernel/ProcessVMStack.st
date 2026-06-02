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
