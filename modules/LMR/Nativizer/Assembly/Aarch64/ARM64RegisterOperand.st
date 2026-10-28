"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64RegisterOperand,
	#superclass : #ARM64OperandSpec,
	#instVars : [
		'letter',
		'sp',
		'field'
	],
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64RegisterOperand class >> fromToken: aString fields: aDictionary [
	| name sp field |
	name := 'R' , ((aString copyFrom: 2) upTo: $|).
	sp := aString endsWith: '|SP'.
	field := aDictionary at: name.
	^self new letter: aString first sp: sp field: field
]

{ #category : #accessing }
ARM64RegisterOperand >> letter: aCharacter sp: aBoolean field: anARM64Field [
	letter := aCharacter.
	sp := aBoolean.
	field := anARM64Field
]

{ #category : #encoding }
ARM64RegisterOperand >> accepts: operand [
	(operand isKindOf: ARM64Register) ifFalse: [^false].
	letter = $D ifTrue: [^operand isFloat and: [operand length >= 64]].
	letter = $S ifTrue: [^operand isFloat and: [operand length = 32]].
	operand isGeneral ifFalse: [^false].
	(sp ifTrue: [operand isZero] ifFalse: [operand isSP]) ifTrue: [^false].
	^letter = $X or: [operand length <= 32]
]

{ #category : #encoding }
ARM64RegisterOperand >> encode: operand [
	^field place: operand index
]
