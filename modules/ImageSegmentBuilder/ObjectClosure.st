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
		'mapping'
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

{ #category : #closure }
ObjectClosure >> addSlotsOf: anObject [
	| b |
	b := anObject behavior.
	self follow: b.
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
	surrogate _isSmallInteger ifFalse: [queue add: surrogate]
]

{ #category : #accessing }
ObjectClosure >> imports [
	^Dictionary new
]

{ #category : #initialization }
ObjectClosure >> initialize [
	mapping := IdentityDictionary new.
	queue := OrderedCollection new: 2000.
	added := IdentitySet new: 2000.
	objects := OrderedCollection new: 2000.
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

