Class {
	#name : #Builder,
	#superclass : #Object,
	#instVars : [
		'module',
		'closure',
		'wordSize',
		'classes'
	],
	#category : #'Builder'
}

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

{ #category : #accessing }
Builder >> closure [
	^closure
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
	saved := (classes includes: aClass instanceClass)
		ifTrue: [original collect: [:method | module originalMethodFor: method]]
		ifFalse: [Dictionary new].
    saved := saved select: [:method | method notNil].
	saved do: [:method | closure map: method to: method copy].
    closure map: original to: saved
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
	closure := ObjectClosure new
]

{ #category : #accessing }
Builder >> map: anObject to: anotherObject [
	closure map: anObject to: anotherObject
]

{ #category : #accessing }
Builder >> module: aModule [
	module := aModule.
]
