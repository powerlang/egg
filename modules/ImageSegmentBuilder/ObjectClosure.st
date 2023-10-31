"
    Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ObjectClosure,
	#superclass : #Object,
	#instVars : [
		'queue',
		'added',
		'objects',
		'mapping',
		'boundary',
		'scope'
	],
	#category : #'ObjectClosure'
}

{ #category : #closure }
ObjectClosure >> traverse: anObject [
	| obj |
	queue add: anObject.
	[ queue isEmpty ]
		whileFalse: [
			obj := queue removeFirst.
			self addSlotsOf: obj ]
]

{ #category : #accessing }
ObjectClosure >> scope: classes [
	scope addAll: classes
]

{ #category : #accessing }
ObjectClosure >> addBoundary: aClass [
	aClass name = 'ModuleLoader' ifTrue: [self _halt].
	boundary add: aClass
]


{ #category : #closure }
ObjectClosure >> addSlotsOf: anObject [
	| behavior |
	behavior := anObject behavior.
	(scope includes: behavior classBinding)
		ifTrue: [self follow: behavior]
		ifFalse: [self addBoundary: behavior classBinding].
	1 to: anObject _pointersSize do: [ :i | | slot |
		slot := anObject _basicAt: i.
		self follow: slot ]
]

{ #category : #closure }
ObjectClosure >> follow: anObject [
	| surrogate | 
	surrogate := self surrogateFor: anObject.
"	(surrogate isNil or: [surrogate _isSmallInteger]) ifTrue: [^self]."
	(added includes: surrogate) ifTrue: [^self].
	added add: surrogate.
	objects add: surrogate.
	(boundary includes: surrogate) ifTrue: [^self].
	(anObject isSpecies andNot: [scope includes: anObject])
		ifTrue: [
			self addBoundary: anObject.
			^self].
	surrogate _isSmallInteger ifFalse: [queue add: surrogate].
]

{ #category : #accessing }
ObjectClosure >> boundary [
	^boundary
]

{ #category : #initialization }
ObjectClosure >> initialize [
	mapping := IdentityDictionary new.
	queue := OrderedCollection new: 2000.
	added := IdentitySet new: 2000.
	objects := OrderedCollection new: 2000.
	boundary := IdentitySet new: 100.
	scope := Set new
]

{ #category : #services }
ObjectClosure >> map: anObject to: anotherObject [
	mapping at: anObject put: anotherObject
]

{ #category : #accessing }
ObjectClosure >> mapping [
	^mapping
]

{ #category : #services }
ObjectClosure >> objects [
	^objects
]

{ #category : #accessing }
ObjectClosure >> roots: aCollection [
	roots := aCollection
]

{ #category : #accessing }
ObjectClosure >> surrogateFor: anObject [
	^mapping at: anObject ifAbsent: [anObject]
]

