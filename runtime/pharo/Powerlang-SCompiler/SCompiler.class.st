Class {
	#name : 'SCompiler',
	#superclass : 'Object',
	#instVars : [
		'errorHandler',
		'result',
		'class'
	],
	#category : 'Powerlang-SCompiler-Frontend',
	#package : 'Powerlang-SCompiler',
	#tag : 'Frontend'
}

{ #category : 'services' }
SCompiler class >> compile: aString in: aClass [
	| compiler |
	compiler := self forClass: aClass.
	^compiler compile: aString
]

{ #category : 'instance creation' }
SCompiler class >> forClass: aClass [
	^self new forClass: aClass
]

{ #category : 'services' }
SCompiler class >> parse: aString in: aClass [
	| compiler |
	compiler := self forClass: aClass.
	^compiler parse: aString
]

{ #category : 'testing' }
SCompiler >> canBeInIdentifier: aCharacter [
	^aCharacter isLetter or: [aCharacter isDigit] or: [aCharacter = $_]
]

{ #category : 'testing' }
SCompiler >> canStartIdentifier: aCharacter [
	^aCharacter isLetter or: [aCharacter = $_]
]

{ #category : 'initialization' }
SCompiler >> classBinding [
	 ^class
]

{ #category : 'initialization' }
SCompiler >> classBinding: aSpecies [
	| instance |
	class := aSpecies.
	instance := aSpecies instanceSide.
	(instance respondsTo: #configureCompiler)
		ifTrue: [instance configureCompiler: self]
]

{ #category : 'services' }
SCompiler >> compile: aString [
	result := self smalltalkCompiler compileMethod: aString.
	^result method
]

{ #category : 'private' }
SCompiler >> forClass: aClass [
	| c |
	c := aClass ifNil: [UndefinedObject].
	self classBinding: c
]

{ #category : 'initialization' }
SCompiler >> initialize: aDictionary [
	class := aDictionary at: #UndefinedObject ifAbsent: nil
]

{ #category : 'services' }
SCompiler >> parse: aString [
	result := self smalltalkCompiler parseMethod: aString.
	^result ast
]

{ #category : 'testing' }
SCompiler >> peekForIdentifier: aStream [
	| char next |
	char := aStream peek.
	(self canBeInIdentifier: char) ifTrue: [
		aStream skip: 1.
		^true].
	char = $. ifFalse: [^false].
	aStream prev isLetter ifFalse: [
		aStream skip: 1.
		^false].
	next := aStream skip: 2; peek.
	next isNil ifTrue: [
		aStream skip: -1.
		^false].
	^next isLetter ifFalse: [aStream skip: -1]; yourself
]

{ #category : 'testing' }
SCompiler >> protect: aBlock [
	^aBlock value
]

{ #category : 'services' }
SCompiler >> smalltalkCompiler [
	^ SSmalltalkCompiler new frontend: self
]

{ #category : 'services' }
SCompiler >> smalltalkParser [
	^ self smalltalkCompiler parser
]

{ #category : 'services' }
SCompiler >> smalltalkScanner [
	^ self smalltalkCompiler scanner
]
