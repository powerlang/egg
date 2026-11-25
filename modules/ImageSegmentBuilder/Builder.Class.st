'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Builder category: #ImageSegmentBuilder!
Object subclass: #Builder
	instanceVariableNames: 'module closure classes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ImageSegmentBuilder'!
!Builder methodsFor:  'degugging' stamp: 'KenD 28/Jun/2026 13:27:39'!
activateDebugMode
	closure activateDebugMode
! !

!Builder methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
addNilToken
	closure analyze: closure nilToken from: HashTable nilToken
! !

!Builder methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
importNilToken
	closure addBoundary: closure nilToken as: SymbolicReference nilToken
! !

!Builder methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
addBoundary: anObject as: aSymbolicReference
	closure addBoundary: anObject as: aSymbolicReference
! !

!Builder methodsFor:  'closure' stamp: 'KenD 28/Jun/2026 13:27:39'!
build
	| metaclasses |
    classes := module classes.
	classes do: [:c | self mapClass: c].
	module prepareForSnapshot: self.
	metaclasses := classes collect: [:c | c class].
	closure scope: classes , metaclasses; traverse: module.
! !

!Builder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
closure
	^closure
! !

!Builder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objects
	^closure objects
! !

!Builder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapping
	^closure mapping
! !

!Builder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^closure boundary
! !

!Builder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapClass: aClass
	self
		mapSubclassesOf: aClass;
		mapMethodsOf: aClass;
		mapMethodsOf: aClass class
! !

!Builder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapMethodsOf: aClass
    | original saved |
    original := aClass methodDictionary.
	saved := original collect: [:method | module originalMethodFor: method].
    saved := saved select: [:method | method notNil].
	saved do: [:method | self mapMethod: method].
    closure map: original to: saved
! !

!Builder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapMethod: method
	| copy |
	copy := method copy.
	closure map: method to: copy.
	method hasBlocks ifFalse: [^self].
	method withIndexDo: [:b :i | | bcopy |
		b isBlock ifTrue: [
			bcopy := copy at: i.
			closure map: b to: bcopy]]
! !

!Builder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapSubclassesOf: aClass
    | original saved |
    original := aClass subclasses.
    saved := original select: [:s | module classes includes: s].
    closure map: original to: saved
! !

!Builder methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	closure := ObjectClosure new builder: self
! !

!Builder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
map: anObject to: anotherObject
	closure map: anObject to: anotherObject
! !

!Builder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
module
	^module
! !

!Builder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
module: aModule
	module := aModule.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Builder class' category: #ImageSegmentBuilder!
Builder class
	instanceVariableNames: ''!


Builder initialize!

