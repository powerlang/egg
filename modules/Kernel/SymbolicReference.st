"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #SymbolicReference,
	#superclass : #Object,
	#instVars : [
		'token',
		'object'
	],
	#category : #Kernel
}

{ #category : #comparing }
SymbolicReference >> = anSymbolicReference [
	anSymbolicReference class == self class ifFalse: [^false].
	^anSymbolicReference token = token
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

{ #category : #accessing }
SymbolicReference >> token [
	^token
]

{ #category : #accessing }
SymbolicReference >> token: string [
	token := string
]
