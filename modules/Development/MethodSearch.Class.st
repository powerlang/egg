'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #MethodSearch category: #Development!
CodeSearch subclass: #MethodSearch
	instanceVariableNames: 'scope next'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!MethodSearch commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
& aMethodSearch
	self class == MethodSearch ifTrue: [
		scope isDefault ifFalse: [aMethodSearch scope: scope].
		^aMethodSearch].
	next notNil ifTrue: [next & aMethodSearch] ifFalse: [next := aMethodSearch]
! !

!MethodSearch methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
addResult: aCompiledMethod
	| m |
	m := next notNil
		ifTrue: [aCompiledMethod]
		ifFalse: [CodeSearchResult method: aCompiledMethod].
	results add: m
! !

!MethodSearch methodsFor:  'scope' stamp: 'KenD 28/Jun/2026 13:32:24'!
amongMethods: aCollection
	scope := aCollection
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
assigningVariable: aString
	^self & (self class assigningVariable: aString)
! !

!MethodSearch methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultScope
	^MethodSearchScope default
! !

!MethodSearch methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
doSearch
	scope methods do: [:m | self addResult: m]
! !

!MethodSearch methodsFor:  'scope' stamp: 'KenD 28/Jun/2026 13:32:24'!
inClass: class
	scope := MethodSearchScope class: class
! !

!MethodSearch methodsFor:  'scope' stamp: 'KenD 28/Jun/2026 13:32:24'!
includeClassSide: aBoolean
	scope includeClassSide: aBoolean
! !

!MethodSearch methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	scope := self defaultScope
! !

!MethodSearch methodsFor:  'scope' stamp: 'KenD 28/Jun/2026 13:32:24'!
inProject: project
	scope := MethodSearchScope project: project
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
referencingClass: aClass
	^self & (self class referencingClass: aClass)
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
referencingString: aString
	^self & (self class referencingString: aString)
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
referencingVariable: aString
	^self & (self class referencingVariable: aString)
! !

!MethodSearch methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
scope
	^scope
! !

!MethodSearch methodsFor:  'scope' stamp: 'KenD 28/Jun/2026 13:32:24'!
scope: aMethodSearchScope
	scope := aMethodSearchScope
! !

!MethodSearch methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
search
	self reset; doSearch.
	^next notNil
		ifTrue: [next amongMethods: results; search]
		ifFalse: [results]
! !

!MethodSearch methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
searchEvaluating: aBlock
	scope do: [:m | (aBlock value: m) ifTrue: [self addResult: m]].
	^results
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
sending: aSymbol
	^self & (self class sending: aSymbol)
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
underCategory: aString
	^self & (self class underCategory: aString)
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
usingVariable: aString
	^self & (self class usingVariable: aString)
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
withSelector: aSymbol
	^self & (self class withSelector: aSymbol)
! !

!MethodSearch methodsFor:  'combining' stamp: 'KenD 28/Jun/2026 13:32:24'!
withSelectorMatching: aString
	^self & (self class withSelectorMatching: aString)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MethodSearch class' category: #Development!
MethodSearch class
	instanceVariableNames: ''!

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
assigningVariable: aString
	^VariableAccessSearch new type: #assign; text: aString
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
referencingClass: aClass
	^ClassReferenceSearch new text: aClass name
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
referencingString: aString
	^StringReferenceSearch new text: aString
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
referencingVariable: aString
	^VariableAccessSearch new type: #reference; text: aString
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
sending: aSymbol
	^SenderSearch new text: aSymbol
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
underCategory: aString
	^CategorySearch new text: aString
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
usingVariable: aString
	^VariableAccessSearch new type: #use; text: aString
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
withSelector: aSymbol
	^ImplementorSearch new text: aSymbol
! !

!MethodSearch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
withSelectorMatching: aString
	^ImplementorSearch new pattern: aString
! !


MethodSearch initialize!

