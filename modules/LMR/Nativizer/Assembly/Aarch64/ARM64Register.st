"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	An ARM64 (AArch64) general-purpose register. Index follows the standard
	encoding: x0..x30 = 0..30, sp/zr = 31 (context-dependent).
	`length` is the operand bitwidth (32 for w*, 64 for x*).
"
Class {
	#name : #ARM64Register,
	#superclass : #Object,
	#instVars : [
		'name',
		'index',
		'length'
	],
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64Register class >> name: aString index: anInteger length: bits [
	^self new name: aString; index: anInteger; length: bits; yourself
]

{ #category : #accessing }
ARM64Register >> index [
	^index
]

{ #category : #accessing }
ARM64Register >> index: anInteger [
	index := anInteger
]

{ #category : #accessing }
ARM64Register >> length [
	^length
]

{ #category : #accessing }
ARM64Register >> length: bits [
	length := bits
]

{ #category : #accessing }
ARM64Register >> name [
	^name
]

{ #category : #accessing }
ARM64Register >> name: aString [
	name := aString
]

{ #category : #printing }
ARM64Register >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #accessing }
ARM64Register >> byte [
	^self
]

{ #category : #accessing }
ARM64Register >> word [
	^self
]

{ #category : #accessing }
ARM64Register >> e [
	^self
]

{ #category : #accessing }
ARM64Register >> r [
	^self
]


