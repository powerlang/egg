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
	module prepareForSnapshot: self.
	closure traverse: module.
]

{ #category : #accessing }
Builder >> closure [
	^closure
]

{ #category : #private }
Builder >> configureClass: aClass [
	self
		configureSuperclass: aClass;
		configureSubclasses: aClass;
		configureMethods: aClass;
		configureMethods: aClass class
]

{ #category : #private }
Builder >> configureMethods: aClass [
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
Builder >> configureSubclasses: aClass [
    | original saved |
    original := aClass subclasses.
    saved := original select: [:s | module classes includes: s].
    closure map: original to: saved
]

{ #category : #private }
Builder >> configureSuperclass: aClass [
    | superclass |
    superclass := aClass superclass.
	superclass ifNil: [^self].
    (module classes includes: superclass) ifFalse: [self import: superclass]
]

{ #category : #initializing }
Builder >> initialize [
	closure := ObjectClosure new.
]

{ #category : #accessing }
Builder >> map: anObject to: anotherObject [
	closure map: anObject to: anotherObject
]

{ #category : #accessing }
Builder >> module: aModule [
	module := aModule.
	classes := module classes.
    module classes do: [:c | self configureClass: c]
]
