"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRModule,
	#superclass : #Module,
	#category : #Kernel

}

{ #category : #spec }
LMRModule >> imports [
	^{
		#Kernel -> #(ArrayedCollection CharacterArray Closure Float ProtoObject Species Symbol)
	}
] 

