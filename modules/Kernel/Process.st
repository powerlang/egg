"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #Process,
	#superclass : #Object,
	#instVars : [
		'stack',
		'name',
		'hopping'
	],
	#category : #Kernel
}

{ #category : #private }
Process >> wantsToStepInto [
	| answer |
	answer := hopping.
	answer ifTrue: [hopping := false].
	^answer
]

