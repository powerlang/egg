"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	An operand of an ARM64InstructionSpec, made from its syntax in the
	encodings table. It tells whether an operand fits it and encodes it
	into the bits of its field.
"

Class {
	#name : #ARM64OperandSpec,
	#superclass : #Object,
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64OperandSpec class >> fromToken: aString fields: aDictionary [
	aString = '#bimm' ifTrue: [^ARM64BitmaskOperand fields: aDictionary].
	aString first = $# ifTrue: [^ARM64ImmediateOperand fromToken: aString fields: aDictionary].
	aString = 'cond' ifTrue: [^ARM64ConditionOperand fields: aDictionary].
	(aString at: 2) isLowercase ifTrue: [^ARM64RegisterOperand fromToken: aString fields: aDictionary].
	^ARM64FixedOperand new symbol: aString asSymbol
]

{ #category : #encoding }
ARM64OperandSpec >> accepts: operand [
	^self subclassResponsibility
]

{ #category : #encoding }
ARM64OperandSpec >> encode: operand [
	^self subclassResponsibility
]
