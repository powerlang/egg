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
		'scope',
		'builder'
	],
	#category : #ImageSegmentBuilder
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
ObjectClosure >> addBoundary: anObject [
	self addBoundary: anObject as: anObject asSymbolicReference
]

{ #category : #accessing }
ObjectClosure >> addBoundary: anObject as: aSymbolicReference [
	boundary at: anObject put: aSymbolicReference
]

{ #category : #accessing }
ObjectClosure >> addKernelBoundaries [
	| symref |
	symref := SymbolicReference new token: #nilToken.
	self addBoundary: HashTable nilToken as: symref.
]


{ #category : #closure }
ObjectClosure >> addSlotsOf: anObject [
	self analyze: anObject behavior.
	1 to: anObject _pointersSize do: [ :i | | slot |
		slot := anObject _basicAt: i.
		self analyze: slot ]
]

{ #category : #closure }
ObjectClosure >> analyze: anObject [
	| surrogate | 
	surrogate := self surrogateFor: anObject.
	surrogate _isSmallInteger ifTrue: [^self].
	(boundary includesKey: surrogate) ifTrue: [^self].
	(added includes: surrogate) ifTrue: [^self].
	(surrogate shouldBeStoredIn: self) ifFalse: [^self addBoundary: surrogate].

	added add: surrogate.
	objects add: surrogate.
	queue add: surrogate.
]

{ #category : #accessing }
ObjectClosure >> boundary [
	^boundary
]

{ #category : #accessing }
ObjectClosure >> builder [
	^builder
]

{ #category : #accessing }
ObjectClosure >> builder: aBuilder [
	builder := aBuilder
]

{ #category : #initialization }
ObjectClosure >> initialize [
	mapping := IdentityDictionary new.
	queue := OrderedCollection new: 2000.
	added := IdentitySet new: 2000.
	objects := OrderedCollection new: 2000.
	boundary := IdentityDictionary new: 100.
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

{ #category : #accessing }
ObjectClosure >> module [
	^builder module
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
ObjectClosure >> scope [
	^scope
]

{ #category : #accessing }
ObjectClosure >> surrogateFor: anObject [
	^mapping at: anObject ifAbsent: [anObject]
]

