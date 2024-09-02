"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #SymbolicReference,
	#superclass : #Object,
	#instVars : [
		'linker',
		'token',
		'object'
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
	^self new linker: #asClass; token: {aClass module name. aClass name}
]

{ #category : #knownObjects }
SymbolicReference class >> forMetaclass: aMetaclass [
	^(self forClass: aMetaclass instanceClass) linker: #asMetaclass
]

{ #category : #knownObjects }
SymbolicReference class >> forCharacter: aCharacter [
	^self new linker: #asCharacter; token: aCharacter codePoint asString
]

{ #category : #knownObjects }
SymbolicReference class >> forModule: aModule [
	^self new linker: #asModule; token: aModule name
]

{ #category : #knownObjects }
SymbolicReference class >> forSymbol: aSymbol [
	^self new linker: #asSymbol; token: aSymbol
]

{ #category : #knownObjects }
SymbolicReference class >> nilToken [
	^self new linker: #nilToken
]

{ #category : #knownObjects }
SymbolicReference class >> symbolTable [
	^self new linker: #symbolTable
]

SymbolicReference class >> linker: anObject token: anotherObject [
	^self new linker: anObject; token: anotherObject
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
	^self perform: linker
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
