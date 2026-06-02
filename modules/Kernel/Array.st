"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Array,
	#superclass : #ArrayedCollection,
	#type : #variable,
	#category : #Kernel
}

{ #category : #converting }
Array >> asArray [
	^self
]

{ #category : #converting }
Array >> asByteArray [
	^ByteArray withAll: self
]

{ #category : #printing }
Array >> canBePrintedAsLiteral [
	^Recursion
		checkOn: self
		while: [self conform: [:each | each canBePrintedAsLiteral]]
		onSignal: [false]
]

{ #category : #printing }
Array >> printOn: aStream [
	self canBePrintedAsLiteral
		ifTrue: [self printAsLiteralOn: aStream]
		ifFalse: [super printOn: aStream]
]

{ #category : #printing }
Array >> printAsLiteralOn: aStream [
	aStream nextPutAll: '#('.
	1 to: self size do: [:i |
		i > 1 ifTrue: [aStream space].
		(self at: i) printOn: aStream].
	aStream nextPut: $)
]

{ #category : #unclassified }
Array >> crash [
	| t |
	t := 1.
	self do: [:each | | n |
		n := self size + each + t.
		(1 to: n) do: [:i | i]].
	^self size
]

{ #category : #testing }
Array >> isArray [
	^true
]

