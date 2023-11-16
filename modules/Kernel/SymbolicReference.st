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

{ #category : #knownObjects }
SymbolicReference class >> forBehavior: aBehavior [
	| species linker |
	species :=  aBehavior classBinding.
	linker := species isMetaclass ifTrue: [#asMetaclassBehavior] ifFalse: [#asBehavior].
	^(self forClass: species instanceClass) linker: linker
]

{ #category : #knownObjects }
SymbolicReference class >> forClass: aClass [
	^self new token: {aClass module name. aClass name}; linker: #asClass
]

{ #category : #knownObjects }
SymbolicReference class >> forMetaclass: aMetaclass [
	^(self forClass: aMetaclass instanceClass) linker: #asMetaclass
]

{ #category : #knownObjects }
SymbolicReference class >> forCharacter: aCharacter [
	^self new token: aCharacter codePoint asString; linker: #asCharacter
]

{ #category : #knownObjects }
SymbolicReference class >> forModule: aModule [
	^self new token: aModule name; linker: #asModule
]

{ #category : #knownObjects }
SymbolicReference class >> forSymbol: aSymbol [
	^self new token: aSymbol; linker: #asSymbol
]

{ #category : #knownObjects }
SymbolicReference class >> nilToken [
	^self new token: #nilToken
]

{ #category : #knownObjects }
SymbolicReference class >> symbolTable [
	^self new token: #symbolTable
]

SymbolicReference class >> token: anObject linker: anotherObject [
	^self new token: anObject; linker: anotherObject
]

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
SymbolicReference >> asCharacter [
	^(Integer fromString: token) asCharacter
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
SymbolicReference >> asMetaclassBehavior [
	^self asClass behavior
]

{ #category : #linking }
SymbolicReference >> asModule [
	^Kernel load: token
]

{ #category : #linking }
SymbolicReference >> asSymbol [
	^token asSymbol
]

{ #category : #services }
SymbolicReference >> hasBeenLinked [
	^object notNil or: [token == #nil]
]

{ #category : #services }
SymbolicReference >> link [
	^self hasBeenLinked ifTrue: [object] ifFalse: [object := self referredValue].
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

{ #category : #linking }
SymbolicReference >> symbolTable [
	^Symbol symbolTable
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
