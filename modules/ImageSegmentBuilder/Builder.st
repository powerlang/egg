Class {
	#name : #Builder,
	#superclass : #Object,
	#instVars : [
		'module',
		'closure',
		'classes'
	],
	#category : #ImageSegmentBuilder
}

{ #category : #degugging }
Builder >> activateDebugMode [
	closure activateDebugMode
]
{ #category : #closure }
Builder >> addNilToken [
	closure analyze: closure nilToken from: HashTable nilToken
]

{ #category : #closure }
Builder >> importNilToken [
	closure addBoundary: closure nilToken as: SymbolicReference nilToken
]

{ #category : #closure }
Builder >> addBoundary: anObject as: aSymbolicReference [
	closure addBoundary: anObject as: aSymbolicReference
]

{ #category : #closure }
Builder >> build [
	| metaclasses |
    classes := module classes.
	classes do: [:c | self mapClass: c].
	module prepareForSnapshot: self.
	metaclasses := classes collect: [:c | c class].
	closure scope: classes , metaclasses; traverse: module.
]

{ #category : #accessing }
Builder >> closure [
	^closure
]

{ #category : #accessing }
Builder >> objects [
	^closure objects
]

{ #category : #accessing }
Builder >> mapping [
	^closure mapping
]

{ #category : #accessing }
Builder >> imports [
	^closure boundary
]

{ #category : #private }
Builder >> mapClass: aClass [
	self
		mapSubclassesOf: aClass;
		mapMethodsOf: aClass;
		mapMethodsOf: aClass class
]

{ #category : #private }
Builder >> mapMethodsOf: aClass [
    | original saved |
    original := aClass methodDictionary.
	saved := original collect: [:method | module originalMethodFor: method].
    saved := saved select: [:method | method notNil].
	saved do: [:method | self mapMethod: method].
    closure map: original to: saved
]

{ #category : #private }
Builder >> mapMethod: method [
	| copy |
	copy := method copy.
	closure map: method to: copy.
	method hasBlocks ifFalse: [^self].
	method withIndexDo: [:b :i | | bcopy |
		b isBlock ifTrue: [
			bcopy := copy at: i.
			closure map: b to: bcopy]]
]

{ #category : #private }
Builder >> mapSubclassesOf: aClass [
    | original saved |
    original := aClass subclasses.
    saved := original select: [:s | module classes includes: s].
    closure map: original to: saved
]

{ #category : #initializing }
Builder >> initialize [
	closure := ObjectClosure new builder: self
]

{ #category : #accessing }
Builder >> map: anObject to: anotherObject [
	closure map: anObject to: anotherObject
]

{ #category : #accessing }
Builder >> module [
	^module
]

{ #category : #accessing }
Builder >> module: aModule [
	module := aModule.
]
