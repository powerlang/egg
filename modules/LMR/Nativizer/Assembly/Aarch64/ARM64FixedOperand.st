"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64FixedOperand,
	#superclass : #ARM64OperandSpec,
	#instVars : [
		'symbol'
	],
	#category : #Aarch64
}

{ #category : #accessing }
ARM64FixedOperand >> symbol: aSymbol [
	symbol := aSymbol
]

{ #category : #encoding }
ARM64FixedOperand >> accepts: operand [
	^operand = symbol
]

{ #category : #encoding }
ARM64FixedOperand >> encode: operand [
	^0
]
