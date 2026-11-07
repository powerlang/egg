"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRModule,
	#superclass : #Module,
	#category : #Kernel

}

{ #category : #initialization }
LMRModule >> justLoaded [
	super justLoaded.
	namespace at: #LastHash put: 1
]

{ #category : #spec }
LMRModule >> imports [
	^{
		#Kernel -> #(ActiveProcess ArrayedCollection ByteArray Character CharacterArray Closure CompiledMethod Float HashTable HostSystem LargeNegativeInteger LargePositiveInteger Message Namespace ProcessLMRStack ProcessStack Processor ProtoObject Species String Symbol WordSize WordSizeShift).
		#FFI -> #(LibC)
	}
] 

