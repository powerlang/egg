"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64Field,
	#superclass : #Object,
	#instVars : [
		'position',
		'width'
	],
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64Field class >> at: position width: width [
	^self new position: position width: width
]

{ #category : #accessing }
ARM64Field >> position: anInteger width: bits [
	position := anInteger.
	width := bits
]

{ #category : #accessing }
ARM64Field >> width [
	^width
]

{ #category : #encoding }
ARM64Field >> place: anInteger [
	| mask |
	mask := (1 bitShift: width) - 1.
	^(anInteger bitAnd: mask) bitShift: position
]
