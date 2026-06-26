"
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"
Class {
	#name : #IntelModule,
	#superclass : #Module,
	#category : #Intel
}

{ #category : #initialization }
IntelModule >> imports [
	^{
		#Kernel -> #(ByteArray Character).
		#LMR -> #(NativeCode).
		#'LMR.Nativizer.Assembly' -> #(ABI Assembler GenericAssembler CodeGenerator RelocatableBuffer)
	}
]

{ #category : #initialization }
IntelModule >> justLoaded [
	| registers prefixes |
	super justLoaded.
	ISAOperandType initializeOperandTypeFlags; initializeTypes.
	InstructionPrefix initializePrefixes.
	Register addNamespace: ISAOperandType operandTypeFlags; initializeRegisters; initializeFamilies.
	ISAOperandType addNamespace: Register registers.
	registers := Register registers.
	self bindAll: registers.
	prefixes := InstructionPrefix classVarNamed: #Prefixes.
	{REXPrefix. LegacyPrefix. InstructionPrefix} do: [:cls | cls addNamespace: prefixes].
	InstructionSpec addNamespace: Character namedCharacters.
	InstructionSpec initialize.
	InstructionEncoder initialize
]

