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
ProcessVMStack >> bpAt: anInteger [
	<primitive: ProcessVMStackBpAt>
]

{ #category : 'Primitives' }
ProcessVMStack >> bpAt: anInteger put: anotherInteger [
	<primitive: ProcessVMStackBpAtPut>
]

{ #category : 'Primitives' }
ProcessVMStack >> pcAt: anInteger [
	<primitive: ProcessVMStackPcAt>
]

{ #category : 'Primitives' }
ProcessVMStack >> pcAt: anInteger put: anotherInteger [
	<primitive: ProcessVMStackPcAtPut>
]

{ #category : 'Primitives' }
ProcessVMStack >> contextSwitchTo: aProcessStack [
	<primitive: ProcessVMStackContextSwitchTo>
]
