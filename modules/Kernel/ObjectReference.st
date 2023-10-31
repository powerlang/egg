"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ObjectReference,
	#superclass : #Object,
	#instVars : [
		'source',
		'sourceOffset',
		'target',
		'absolute'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ObjectReference class >> absoluteFor: anObject [
	^(self new for: anObject) beAbsolute
]

{ #category : #actions }
ObjectReference >> beAbsolute [
	absolute := true
]

{ #category : #actions }
ObjectReference >> classBinding [
	^source classBinding
]

{ #category : #'instance creation' }
ObjectReference >> for: anObject [
	self target: anObject
]

{ #category : #initialization }
ObjectReference >> initialize [
	absolute := false
]

{ #category : #testing }
ObjectReference >> isAbsolute [
	^absolute
]

{ #category : #testing }
ObjectReference >> isMethod [
	^false
]

{ #category : #printing }
ObjectReference >> printOn: aStream [
	aStream nextPutAll: 'Ref to ' , target printString
]

{ #category : #accessing }
ObjectReference >> source: sourceObject [
	source := sourceObject
]

{ #category : #accessing }
ObjectReference >> sourceOffset [
	^sourceOffset
]

{ #category : #accessing }
ObjectReference >> sourceOffset: aNumber [
	sourceOffset := aNumber
]

{ #category : #accessing }
ObjectReference >> target [
	^target
]

{ #category : #accessing }
ObjectReference >> target: anObject [
	target := anObject
]

{ #category : #accessing }
ObjectReference >> targetOffset [
	^0
]

{ #category : #unclassified }
ObjectReference >> valueToWriteAt: sourceAddress targeting: targetAddress with: wordSize [
	| address correction |
	address := targetAddress + self targetOffset.
	correction := absolute
		ifTrue: [0]
		ifFalse: [sourceAddress + sourceOffset + wordSize].
	^address - correction
]

{ #category : #accessing }
ObjectReference >> valueToWriteAt: sourceAddress with: wordSize [
	^self
		valueToWriteAt: sourceAddress
		targeting: target _asSmallInteger
		with: wordSize
]

{ #category : #accessing }
ObjectReference >> valueToWriteWith: wordSize [
	^self valueToWriteAt: source _asSmallInteger + sourceOffset with: wordSize
]

