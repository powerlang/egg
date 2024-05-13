"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessVMStack,
	#superclass : #ProcessStack,
	#category : #Kernel
}

{ #category : 'Primitives' }
ProcessVMStack >> at: anInteger [
	<primitive: ProcessVMStackAt>
]

{ #category : 'Primitives' }
ProcessVMStack >> at: anInteger put: anObject [
	<primitive: ProcessVMStackAtPut>
]

{ #category : 'Primitives' }
ProcessVMStack >> basicInitialize [
	<primitive: ProcessVMStackInitialize>
]

{ #category : #primitives }
ProcessVMStack >> bp [
	<primitive: ProcessVMStackBP>
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

{ #category : 'initializing' }
ProcessVMStack >> initialize [
	super initialize.
	self basicInitialize
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
