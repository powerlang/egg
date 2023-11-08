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
		'builder',
		'reversePaths',
		'debug'
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

{ #category : #degugging }
ObjectClosure >> activateDebugMode [
	debug := true.
	reversePaths := IdentityDictionary new: 100.
]

{ #category : #accessing }
ObjectClosure >> addBoundary: anObject [
	self addBoundary: anObject as: anObject asSymbolicReference
]

{ #category : #accessing }
ObjectClosure >> addBoundary: anObject as: aSymbolicReference [
	boundary at: anObject put: aSymbolicReference
]

{ #category : #closure }
ObjectClosure >> addSlotsOf: anObject [
	self analyze: anObject behavior from: anObject.
	1 to: anObject _pointersSize do: [ :i | | slot |
		slot := anObject _basicAt: i.
		self analyze: slot from: anObject]
]

{ #category : #closure }
ObjectClosure >> analyze: anObject from: source [
	| surrogate |
	surrogate := self surrogateFor: anObject.
	surrogate _isSmallInteger ifTrue: [^self].
	(boundary includesKey: surrogate) ifTrue: [^self].
	(added includes: surrogate) ifTrue: [^self].
	(surrogate shouldBeStoredIn: self) ifFalse: [^self addBoundary: surrogate].
	self isDebugging ifTrue: [reversePaths at: anObject put: source].

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

{ #category : #degugging }
ObjectClosure >> isDebugging [
	^debug
]

{ #category : #initialization }
ObjectClosure >> initialize [
	mapping := IdentityDictionary new.
	queue := OrderedCollection new: 2000.
	added := IdentitySet new: 2000.
	objects := OrderedCollection new: 2000.
	boundary := IdentityDictionary new: 100.
	scope := Set new.
	debug := false.
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

{ #category : #debugging }
ObjectClosure >> reversePathOf: anObject [
	| path current |
	path := OrderedCollection new.
	current:= anObject.
	[
		path add: current.
		current := reversePaths at: current ifAbsent: [^path].
	] repeat
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

