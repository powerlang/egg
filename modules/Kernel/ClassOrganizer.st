"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ClassOrganizer,
	#superclass : #Object,
	#instVars : [
		'comment',
		'categories',
		'selectors',
		'author',
		'timestamp',
		'prev'
	],
	#category : #Kernel
}

{ #category : #constants }
ClassOrganizer class >> default [
	^#unclassified
]

{ #category : #updating }
ClassOrganizer >> addCategory: aString [
	| s |
	^(self selectorsFor: (s := aString asSymbol))
		ifNil: [
			self categories add: s.
			selectors add: OrderedCollection new].
	
]

{ #category : #accessing }
ClassOrganizer >> allSelectors [
	selectors isNil ifTrue: [^#()].
	^selectors
		inject: Set new
		into: [:result :each | result addAll: each; yourself]
]

{ #category : #accessing }
ClassOrganizer >> author [
	^author
]

{ #category : #accessing }
ClassOrganizer >> author: aString [
	author := aString
]

{ #category : #accessing }
ClassOrganizer >> categories [
	categories isNil ifTrue: [
		categories := OrderedCollection new.
		selectors := OrderedCollection new].
	^categories
]

{ #category : #private }
ClassOrganizer >> categoriesOn: aClass [
	categories isNil ifTrue: [
		categories := OrderedCollection new.
		selectors := OrderedCollection new].
	self checkDefaultCategoryOn: aClass.
	^categories
]

{ #category : #queries }
ClassOrganizer >> categoryFor: element [
	| index |
	^selectors isNil ifFalse: [
		index := selectors
			findFirst: [:one | one includes: element]
			ifAbsent: [^nil].
		categories at: index]
]

{ #category : #private }
ClassOrganizer >> checkDefaultCategoryOn: aClass [
	| index unclassified all |
	categories isNil ifTrue: [^self].
	index := categories indexOf: self class default.
	index > 0 ifTrue: [
		categories removeIndex: index.
		selectors removeIndex: index].
	unclassified := OrderedCollection new.
	all := self allSelectors.
	aClass selectors
		do: [:s | (all includes: s) ifFalse: [unclassified add: s]].
	unclassified notEmpty
		ifTrue: [self classifyAll: unclassified under: self class default]
]

{ #category : #updating }
ClassOrganizer >> classify: element [
	element == #doit ifTrue: [^self].
	(self categoryFor: element) isNil
		ifTrue: [self classify: element under: self class default]
]

{ #category : #updating }
ClassOrganizer >> classify: element under: category [
	| protocol |
	self remove: element.
	protocol := self getSelectorsFor: category.
	protocol add: element
]

{ #category : #updating }
ClassOrganizer >> classifyAll: elements under: category [
	| protocol |
	elements do: [:s | self remove: s].
	protocol := self getSelectorsFor: category.
	protocol addAll: elements
]

{ #category : #accessing }
ClassOrganizer >> comment [
	^comment ifNil: ['']
]

{ #category : #updating }
ClassOrganizer >> comment: aString [
	comment := aString
]

{ #category : #updating }
ClassOrganizer >> down: category [
	| index |
	index := categories indexOf: category.
	index = categories size ifTrue: [^self].
	categories swap: index with: index + 1.
	selectors swap: index with: index + 1
]

{ #category : #updating }
ClassOrganizer >> getSelectorsFor: heading [
	| h |
	h := heading isNil ifTrue: [self class default] ifFalse: [heading].
	^(self selectorsFor: h) ifNil: [self addCategory: h]
]

{ #category : #private }
ClassOrganizer >> hasValidSelectorsIn: aClass [
	| valid |
	valid := aClass selectors.
	^self allSelectors conform: [:s | valid includes: s]
]

{ #category : #updating }
ClassOrganizer >> move: element to: category [
	self
		remove: element;
		classify: element under: category
]

{ #category : #updating }
ClassOrganizer >> moveCategory: category to: integer [
	| index s |
	(integer between: 1 and: categories size) ifFalse: [^self].
	index := categories indexOf: category.
	index = integer ifTrue: [^self].
	index = 0 ifTrue: [^self].
	categories
		removeIndex: index;
		add: category beforeIndex: integer.
	s := selectors at: index.
	selectors
		removeIndex: index;
		add: s beforeIndex: integer
]

{ #category : #accessing }
ClassOrganizer >> position [
	^prev
]

{ #category : #accessing }
ClassOrganizer >> position: anInteger [
	prev := anInteger
]

{ #category : #copying }
ClassOrganizer >> postCopy [
	categories := categories copy.
	selectors := selectors copy
]

{ #category : #accessing }
ClassOrganizer >> prev [
	^prev
]

{ #category : #accessing }
ClassOrganizer >> prev: ref [
	self ASSERT: false.
	prev := ref
]

{ #category : #queries }
ClassOrganizer >> rebuild [
	| n prevCat |
	prev := selectors.
	n := categories asSet size.
	selectors := Array new: n.
	prevCat := categories.
	categories := OrderedCollection new: n.
	prevCat with: prev do: [:cat :sels | | i |
		i := categories indexOf: cat.
		i = 0 ifTrue: [
			categories add: cat.
			i := categories size].
		(selectors at: i)
			ifNil: [selectors at: i put: sels]
			ifNotNil: [:c | c addAll: sels]].
	selectors := selectors asOrderedCollection
]

{ #category : #removing }
ClassOrganizer >> remove: element [
	selectors isNil ifTrue: [^self].
	selectors do: [:each | each remove: element ifAbsent: nil]
]

{ #category : #updating }
ClassOrganizer >> removeCategory: aString [
	| index |
	categories isNil ifTrue: [^self].
	index := categories indexOf: aString asSymbol.
	index = 0 ifTrue: [^self].
	categories removeIndex: index.
	selectors removeIndex: index
]

{ #category : #updating }
ClassOrganizer >> renameCategory: aSymbol toBe: anotherSymbol [
	| index existing protocol |
	categories isNil ifTrue: [^self].
	index := categories indexOf: aSymbol asSymbol ifAbsent: [^self].
	existing := categories indexOf: anotherSymbol asSymbol ifAbsent: nil.
	existing isNil
		ifTrue: [categories at: index put: anotherSymbol asSymbol]
		ifFalse: [
			protocol := selectors at: index.
			protocol do: [:selector | self move: selector to: anotherSymbol].
			self removeCategory: aSymbol]
]

{ #category : #updating }
ClassOrganizer >> reorganizeWith: categoryCollection [
	categoryCollection withIndexDo: [:c :i | self moveCategory: c to: i]
]

{ #category : #private }
ClassOrganizer >> selectors [
	^selectors
]

{ #category : #queries }
ClassOrganizer >> selectorsFor: aString [
	| index |
	categories isNil ifTrue: [^nil].
	index := categories indexOf: aString asSymbol.
	index = 0 ifTrue: [^nil].
	^selectors at: index
]

{ #category : #accessing }
ClassOrganizer >> timestamp [
	^timestamp
]

{ #category : #accessing }
ClassOrganizer >> timestamp: aTimestamp [
	timestamp := aTimestamp
]

{ #category : #updating }
ClassOrganizer >> up: heading [
	| index |
	index := categories indexOf: heading.
	index = 1 ifTrue: [^self].
	categories swap: index with: index - 1.
	selectors swap: index with: index - 1
]

{ #category : #private }
ClassOrganizer >> updateOn: aClass [
	| valid |
	valid := aClass selectors.
	selectors
		withIndexDo: [:c :i | selectors
			at: i
			put: (c select: [:s | valid includes: s])]
]

