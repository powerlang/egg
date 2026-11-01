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
		#Kernel -> #(ArrayedCollection CharacterArray Closure CompiledMethod Float HashTable Namespace ProcessLMRStack ProcessStack ProtoObject Species Symbol WordSize WordSizeShift)
	}
] 

