'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ClassOrganizer category: #Kernel!
Object subclass: #ClassOrganizer
	instanceVariableNames: 'comment categories selectors author timestamp prev'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ClassOrganizer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
addCategory: aString
	| s |
	^(self selectorsFor: (s := aString asSymbol))
		ifNil: [
			self categories add: s.
			selectors add: OrderedCollection new].
	
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSelectors
	selectors isNil ifTrue: [^#()].
	^selectors
		inject: Set new
		into: [:result :each | result addAll: each; yourself]
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
author
	^author
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
author: aString
	author := aString
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
categories
	categories isNil ifTrue: [
		categories := OrderedCollection new.
		selectors := OrderedCollection new].
	^categories
! !

!ClassOrganizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
categoriesOn: aClass
	categories isNil ifTrue: [
		categories := OrderedCollection new.
		selectors := OrderedCollection new].
	self checkDefaultCategoryOn: aClass.
	^categories
! !

!ClassOrganizer methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
categoryFor: element
	| index |
	^selectors isNil ifFalse: [
		index := selectors
			findFirst: [:one | one includes: element]
			ifAbsent: [^nil].
		categories at: index]
! !

!ClassOrganizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
checkDefaultCategoryOn: aClass
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
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
classify: element
	element == #doit ifTrue: [^self].
	(self categoryFor: element) isNil
		ifTrue: [self classify: element under: self class default]
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
classify: element under: category
	| protocol |
	self remove: element.
	protocol := self getSelectorsFor: category.
	protocol add: element
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
classifyAll: elements under: category
	| protocol |
	elements do: [:s | self remove: s].
	protocol := self getSelectorsFor: category.
	protocol addAll: elements
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
comment
	^comment ifNil: ['']
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
comment: aString
	comment := aString
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
down: category
	| index |
	index := categories indexOf: category.
	index = categories size ifTrue: [^self].
	categories swap: index with: index + 1.
	selectors swap: index with: index + 1
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
getSelectorsFor: heading
	| h |
	h := heading isNil ifTrue: [self class default] ifFalse: [heading].
	^(self selectorsFor: h) ifNil: [self addCategory: h]
! !

!ClassOrganizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasValidSelectorsIn: aClass
	| valid |
	valid := aClass selectors.
	^self allSelectors conform: [:s | valid includes: s]
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
move: element to: category
	self
		remove: element;
		classify: element under: category
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
moveCategory: category to: integer
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
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
position
	^prev
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
position: anInteger
	prev := anInteger
! !

!ClassOrganizer methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	categories := categories copy.
	selectors := selectors copy
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
prev
	^prev
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
prev: ref
	self ASSERT: false.
	prev := ref
! !

!ClassOrganizer methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
rebuild
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
! !

!ClassOrganizer methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: element
	selectors isNil ifTrue: [^self].
	selectors do: [:each | each remove: element ifAbsent: nil]
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeCategory: aString
	| index |
	categories isNil ifTrue: [^self].
	index := categories indexOf: aString asSymbol.
	index = 0 ifTrue: [^self].
	categories removeIndex: index.
	selectors removeIndex: index
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
renameCategory: aSymbol toBe: anotherSymbol
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
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
reorganizeWith: categoryCollection
	categoryCollection withIndexDo: [:c :i | self moveCategory: c to: i]
! !

!ClassOrganizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
selectors
	^selectors
! !

!ClassOrganizer methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
selectorsFor: aString
	| index |
	categories isNil ifTrue: [^nil].
	index := categories indexOf: aString asSymbol.
	index = 0 ifTrue: [^nil].
	^selectors at: index
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
timestamp
	^timestamp
! !

!ClassOrganizer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
timestamp: aTimestamp
	timestamp := aTimestamp
! !

!ClassOrganizer methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:38'!
up: heading
	| index |
	index := categories indexOf: heading.
	index = 1 ifTrue: [^self].
	categories swap: index with: index - 1.
	selectors swap: index with: index - 1
! !

!ClassOrganizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
updateOn: aClass
	| valid |
	valid := aClass selectors.
	selectors
		withIndexDo: [:c :i | selectors
			at: i
			put: (c select: [:s | valid includes: s])]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ClassOrganizer class' category: #Kernel!
ClassOrganizer class
	instanceVariableNames: ''!

!ClassOrganizer class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
default
	^#unclassified
! !


