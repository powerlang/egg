"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"
Class {
	#name : #Aarch64Module,
	#superclass : #Module,
	#category : #Aarch64
}

{ #category : #initialization }
Aarch64Module >> imports [
	^{
		#Kernel -> #(ByteArray Character Dictionary Integer OrderedCollection ProtoObject).
		#LMR -> #(NativeCode).
		#'LMR.Nativizer.Assembly' -> #(ABI Assembler GenericAssembler CodeGenerator RelocatableBuffer RelocationFixup)
	}
]

{ #category : #initialization }
Aarch64Module >> justLoaded [
	super justLoaded.
	self bindAll: ARM64Register registers.
	ARM64InstructionSpec initialize
]
