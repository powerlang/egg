"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #SymbolicReference,
	#superclass : #Object,
	#instVars : [
		'token',
		'object',
		'moduleName',
		'linker'
	],
	#category : #Kernel
}

{ #category : #comparing }
SymbolicReference >> = aSymbolicReference [
	aSymbolicReference class == self class ifFalse: [^false].
	^aSymbolicReference token = token
]

{ #category : #linking }
SymbolicReference >> asBehavior [
	^self asClass instanceBehavior
]

{ #category : #linking }
SymbolicReference >> asClass [
	| module |
	module := Kernel load: token first.
	^module namespace at: token second
]

{ #category : #linking }
SymbolicReference >> asMetaclass [
	^self asClass class
]

{ #category : #linking }
SymbolicReference >> asCharacter [
	^token first
]

{ #category : #linking }
SymbolicReference >> asSymbol [
	^token asSymbol
]

{ #category : #services }
SymbolicReference >> link [
	self hasBeenLinked ifTrue: [object] ifFalse: [object := self referredValue].
]

{ #category : #accessing }
SymbolicReference >> linker [
	^linker
]

{ #category : #accessing }
SymbolicReference >> linker: aSymbol [
	linker := aSymbol
]

{ #category : #linking }
SymbolicReference >> false [
	^false
]

{ #category : #linking }
SymbolicReference >> nil [
	^nil
]

{ #category : #linking }
SymbolicReference >> nilToken [
	^HashTable nilToken
]

{ #category : #accessing }
SymbolicReference >> object [
	^object
]

{ #category : #printing }
SymbolicReference >> printOn: aStream [
	aStream
		nextPutAll: self type;
		nextPutAll: ' (';
		nextPutAll: token printString;
		nextPut: $)
]

{ #category : #services }
SymbolicReference >> referredValue [
	^linker ifNil: [self perform: token] ifNotNil: [self perform: linker]
]

{ #category : #accessing }
SymbolicReference >> token [
	^token
]

{ #category : #accessing }
SymbolicReference >> token: string [
	token := string
]

{ #category : #linking }
SymbolicReference >> true [
	^true
]
