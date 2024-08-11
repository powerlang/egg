"
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"
Class {
	#name : #IntelModule,
	#superclass : #Module,
	#category : #'Powerlang-Core-Assembler-Intel'
}

{ #category : #initialization }
IntelModule >> imports [
	^{#'LMR.Nativizer.Assembly' -> #(ABI Assembler CodeGenerator)}
]

{ #category : #initialization }
IntelModule >> justLoaded [
	ISAOperandType 	initializeOperandTypeFlags; initializeTypes.
	InstructionPrefix initializePrefixes.
	Register addNamespace: ISAOperandType operandTypeFlags; initializeRegisters; initializeFamilies.
	ISAOperandType addNamespace: Register registers
]

