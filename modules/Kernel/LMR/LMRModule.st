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
	linkage := Array new: 6.
	linkage at: 3 put: (String new: 32).
	linkage at: 6 put: (Array new: 16).
	self exportByReference: linkage as: #HostLinkage
]

{ #category : #spec }
LMRModule >> imports [
	^{
		#Kernel -> #(ActiveProcess Array ArrayedCollection ByteArray Character CharacterArray Closure CompiledMethod Float HashTable HostSystem LargeNegativeInteger LargePositiveInteger Message Namespace ProcessLMRStack ProcessStack Processor ProtoObject Species String Symbol WordSize WordSizeShift).
		#FFI -> #(LibC)
	}
] 

