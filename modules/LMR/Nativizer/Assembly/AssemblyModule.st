"
	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #AssemblyModule,
	#superclass : #Module,
	#category : #Assembly
}

{ #category : #spec }
AssemblyModule >> imports [
	^{
		#Kernel -> #(ByteArray OrderedCollection).
		#LMR -> #(NativeCode LMRModule)
	}
]

{ #category : #initialization }
AssemblyModule >> justLoaded [
	super justLoaded.
	Assembler initialize
]
