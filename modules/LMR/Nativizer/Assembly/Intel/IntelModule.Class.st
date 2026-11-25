'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #IntelModule category: #'Powerlang-Core-Assembler-Intel'!
Module subclass: #IntelModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!IntelModule commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!IntelModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
imports
	^{
		#Kernel -> #(ByteArray).
		#LMR -> #(NativeCode).
		#'LMR.Nativizer.Assembly' -> #(ABI Assembler CodeGenerator RelocatableBuffer)
	}
! !

!IntelModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
justLoaded
	super justLoaded.
	ISAOperandType 	initializeOperandTypeFlags; initializeTypes.
	InstructionPrefix initializePrefixes.
	Register addNamespace: ISAOperandType operandTypeFlags; initializeRegisters; initializeFamilies.
	ISAOperandType addNamespace: Register registers
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntelModule class' category: #'Powerlang-Core-Assembler-Intel'!
IntelModule class
	instanceVariableNames: ''!


