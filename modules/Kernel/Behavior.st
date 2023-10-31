"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Behavior,
	#superclass : #Object,
	#instVars : [
		'class',
		'methods',
		'next'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Behavior class >> fromClass: aClass [
	^self new fromClass: aClass
]

{ #category : #'instance creation' }
Behavior class >> new [
	^super new basicHash; yourself
]

{ #category : #'instance creation' }
Behavior class >> with: md [
	^self new methods: md
]

{ #category : #'instance creation' }
Behavior class >> with: md1 with: md2 [
	^self new
		methods: md1;
		next: (self with: md2)
]

{ #category : #'instance creation' }
Behavior class >> with: md withAll: behavior [
	^self new methods: md; next: behavior
]

{ #category : #comparing }
Behavior >> = aBehavior [
	self class = aBehavior class ifFalse: [^false].
	class = aBehavior classBinding ifFalse: [^false].
	methods = aBehavior methods ifFalse: [^false].
	next = aBehavior next ifFalse: [^false].
	^true
]

{ #category : #converting }
Behavior >> asArray [
	^(OrderedCollection from: self iterator: #do:) asArray
]

{ #category : #accessing }
Behavior >> classBinding [
	^class
]

{ #category : #accessing }
Behavior >> classBinding: aSpecies [
	class := aSpecies
]

{ #category : #copying }
Behavior >> copyWithout: behavior [
	| b |
	methods == behavior
		ifTrue: [^next isNil ifTrue: [self class new] ifFalse: [next]].
	next isNil ifTrue: [^self].
	b := next == behavior
		ifTrue: [next next]
		ifFalse: [next copyWithout: behavior].
	^self copy next: b
]

{ #category : #enumerating }
Behavior >> do: aBlock [
	aBlock evaluateWith: methods.
	next notNil ifTrue: [next do: aBlock]
]

{ #category : #services }
Behavior >> enhancedWith: aMethodDictionary [
	^self class with: aMethodDictionary withAll: self
]

{ #category : #inquiries }
Behavior >> findMethodFor: aSymbol [
	self do: [:md | | cm |
		cm := md at: aSymbol ifAbsent: nil.
		cm notNil ifTrue: [^cm]].
	^nil
]

{ #category : #inquiries }
Behavior >> findMethodFor: aSymbol in: aClass [
	self do: [:md | | cm |
		cm := md at: aSymbol ifAbsent: nil.
		(cm notNil and: [cm classBinding == aClass]) ifTrue: [^cm]].
	^nil
]

{ #category : #accessing }
Behavior >> fromClass: aClass [
	class := aClass.
	methods := aClass instanceBehavior methods.
	next := aClass superclass ifNotNil: [:sc | sc instanceBehavior].
	next notNil ifTrue: [self ASSERT: next == self]
]

{ #category : #comparing }
Behavior >> hash [
	^methods hashWith: next
]

{ #category : #testing }
Behavior >> hasInstanceBehavior [
	^class instanceBehavior !== self
]

{ #category : #inquiries }
Behavior >> implements: aSymbol [
	| method |
	method := self findMethodFor: aSymbol.
	^method !== nil
]

{ #category : #testing }
Behavior >> includes: behavior [
	self == behavior ifTrue: [^true].
	methods == behavior ifTrue: [^true].
	^next notNil and: [next includes: behavior]
]

{ #category : #accessing }
Behavior >> instanceBehavior [
	^self hasInstanceBehavior ifTrue: [methods]
]

{ #category : #accessing }
Behavior >> methods [
	^methods
]

{ #category : #accessing }
Behavior >> methods: aMethodDictionary [
	methods := aMethodDictionary
]

{ #category : #accessing }
Behavior >> next [
	^next
]

{ #category : #accessing }
Behavior >> next: aBehavior [
	next := aBehavior
]

{ #category : #testing }
Behavior >> replace: aBehavior with: newBehavior [
	next == aBehavior
		ifTrue: [next := newBehavior]
		ifFalse: [next notNil ifTrue: [next replace: aBehavior with: newBehavior]]
]

