"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64ConditionOperand,
	#superclass : #ARM64OperandSpec,
	#instVars : [
		'field'
	],
	#category : #Aarch64
}

{ #category : #accessing }
ARM64ConditionOperand class >> conditions [
	^#(eq ne cs cc mi pl vs vc hi ls ge lt gt le al nv)
]

{ #category : #'instance creation' }
ARM64ConditionOperand class >> fields: aDictionary [
	| field |
	field := aDictionary at: 'cond'.
	^self new field: field
]

{ #category : #accessing }
ARM64ConditionOperand >> field: anARM64Field [
	field := anARM64Field
]

{ #category : #encoding }
ARM64ConditionOperand >> accepts: operand [
	^self class conditions includes: operand
]

{ #category : #encoding }
ARM64ConditionOperand >> encode: operand [
	| code |
	code := (self class conditions indexOf: operand) - 1.
	^field place: code
]
