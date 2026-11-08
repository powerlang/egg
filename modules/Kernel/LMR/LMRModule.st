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
	| linkage |
	super justLoaded.
	namespace at: #LastHash put: 1.
	linkage := Array with: nil with: nil with: (String new: 32).
	self exportByReference: linkage as: #HostLinkage
]

{ #category : #spec }
LMRModule >> imports [
	^{
		#Kernel -> #(ActiveProcess Array ArrayedCollection ByteArray Character CharacterArray Closure CompiledMethod Float HashTable HostSystem LargeNegativeInteger LargePositiveInteger Message Namespace ProcessLMRStack ProcessStack Processor ProtoObject Species String Symbol WordSize WordSizeShift).
		#FFI -> #(LibC)
	}
] 

