"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64ImmediateOperand,
	#superclass : #ARM64OperandSpec,
	#instVars : [
		'field',
		'scale',
		'signed'
	],
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64ImmediateOperand class >> fromToken: aString fields: aDictionary [
	| name star scale signed field |
	name := aString copyFrom: 2.
	star := name indexOf: $*.
	scale := star = 0 ifTrue: [1] ifFalse: [(name copyFrom: star + 1) asInteger].
	star > 0 ifTrue: [name := name copyFrom: 1 to: star - 1].
	signed := name beginsWith: 'simm'.
	signed ifTrue: [name := name copyFrom: 2].
	field := aDictionary at: name.
	^self new field: field scale: scale signed: signed
]

{ #category : #accessing }
ARM64ImmediateOperand >> field: anARM64Field scale: anInteger signed: aBoolean [
	field := anARM64Field.
	scale := anInteger.
	signed := aBoolean
]

{ #category : #encoding }
ARM64ImmediateOperand >> accepts: operand [
	^operand isInteger and: [(self unitsOf: operand) notNil]
]

{ #category : #encoding }
ARM64ImmediateOperand >> encode: operand [
	| units |
	units := self unitsOf: operand.
	^field place: units
]

{ #category : #private }
ARM64ImmediateOperand >> unitsOf: anInteger [
	| units low high |
	anInteger \\ scale = 0 ifFalse: [^nil].
	units := anInteger // scale.
	high := 1 bitShift: field width.
	low := 0.
	signed ifTrue: [
		high := high // 2.
		low := high negated].
	^(units between: low and: high - 1) ifTrue: [units]
]
