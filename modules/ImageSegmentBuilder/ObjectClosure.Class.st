'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ObjectClosure category: #ImageSegmentBuilder!
Object subclass: #ObjectClosure
	instanceVariableNames: 'queue added objects mapping boundary scope builder nilToken reversePaths debug'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ImageSegmentBuilder'!
!ObjectClosure commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
!

!ObjectClosure methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
traverse: anObject
	| obj |
	queue add: anObject.
	[ queue isEmpty ]
		whileFalse: [
			obj := queue removeFirst.
			self addSlotsOf: obj ]
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
scope: classes
	scope addAll: classes
! !

!ObjectClosure methodsFor:  'degugging' stamp: 'KenD 28/Jun/2026 13:27:39'!
activateDebugMode
	debug := true.
	reversePaths := IdentityDictionary new: 100.
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addBoundary: anObject
	self addBoundary: anObject as: anObject asSymbolicReference
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addBoundary: anObject as: aSymbolicReference
	boundary at: anObject put: aSymbolicReference
! !

!ObjectClosure methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
addSlotsOf: anObject
	self analyze: anObject behavior from: anObject.
	1 to: anObject _pointersSize do: [ :i | | slot |
		slot := anObject _basicAt: i.
		self analyze: slot from: anObject]
! !

!ObjectClosure methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
analyze: anObject from: source
	| surrogate |
	surrogate := self surrogateFor: anObject.
	(boundary includesKey: surrogate) ifTrue: [^self].
	(added includes: surrogate) ifTrue: [^self].
	(surrogate shouldBeStoredIn: self) ifFalse: [^self addBoundary: surrogate].
	self isDebugging ifTrue: [reversePaths at: anObject put: source].
	added add: surrogate.
	objects add: surrogate.
	queue add: surrogate.
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
boundary
	^boundary
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
builder
	^builder
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
builder: aBuilder
	builder := aBuilder
! !

!ObjectClosure methodsFor:  'degugging' stamp: 'KenD 28/Jun/2026 13:27:39'!
isDebugging
	^debug
! !

!ObjectClosure methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	mapping := IdentityDictionary new.
	queue := OrderedCollection new: 2000.
	added := IdentitySet new: 2000.
	objects := OrderedCollection new: 2000.
	boundary := IdentityDictionary new: 100.
	nilToken := Object new.
	scope := Set new.
	debug := false.
! !

!ObjectClosure methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
map: anObject to: anotherObject
	mapping at: anObject put: anotherObject
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapping
	^mapping
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
module
	^builder module
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
nilToken
	^nilToken
! !

!ObjectClosure methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
objects
	^objects
! !

!ObjectClosure methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:39'!
reversePathOf: anObject
	| path current |
	path := OrderedCollection new.
	current:= anObject.
	[
		path add: current.
		current := reversePaths at: current ifAbsent: [^path].
	] repeat
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
roots: aCollection
	roots := aCollection
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
scope
	^scope
! !

!ObjectClosure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
surrogateFor: anObject
	anObject == HashTable nilToken ifTrue: [^nilToken].
	^mapping at: anObject ifAbsent: [anObject]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ObjectClosure class' category: #ImageSegmentBuilder!
ObjectClosure class
	instanceVariableNames: ''!


ObjectClosure initialize!

