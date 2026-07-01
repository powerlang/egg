'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Behavior category: #Kernel!
Object subclass: #Behavior
	instanceVariableNames: 'class methods next'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Behavior commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Behavior methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aBehavior
	self class = aBehavior class ifFalse: [^false].
	class = aBehavior classBinding ifFalse: [^false].
	methods = aBehavior methods ifFalse: [^false].
	next = aBehavior next ifFalse: [^false].
	^true
! !

!Behavior methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asArray
	^(OrderedCollection from: self iterator: #do:) asArray
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classBinding
	^class
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classBinding: aSpecies
	class := aSpecies
! !

!Behavior methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyWithout: behavior
	| b |
	methods == behavior
		ifTrue: [^next isNil ifTrue: [self class new] ifFalse: [next]].
	next isNil ifTrue: [^self].
	b := next == behavior
		ifTrue: [next next]
		ifFalse: [next copyWithout: behavior].
	^self copy next: b
! !

!Behavior methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	aBlock evaluateWith: methods.
	next notNil ifTrue: [next do: aBlock]
! !

!Behavior methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
enhancedWith: aMethodDictionary
	^self class with: aMethodDictionary withAll: self
! !

!Behavior methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
findMethodFor: aSymbol
	self do: [:md | | cm |
		cm := md at: aSymbol ifAbsent: nil.
		cm notNil ifTrue: [^cm]].
	^nil
! !

!Behavior methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
findMethodFor: aSymbol in: aClass
	self do: [:md | | cm |
		cm := md at: aSymbol ifAbsent: nil.
		(cm notNil and: [cm classBinding == aClass]) ifTrue: [^cm]].
	^nil
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromClass: aClass
	class := aClass.
	methods := aClass instanceBehavior methods.
	next := aClass superclass ifNotNil: [:sc | sc instanceBehavior].
	next notNil ifTrue: [self ASSERT: next == self]
! !

!Behavior methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^methods hashWith: next
! !

!Behavior methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInstanceBehavior
	^class instanceBehavior !!== self
! !

!Behavior methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
implements: aSymbol
	| method |
	method := self findMethodFor: aSymbol.
	^method !!== nil
! !

!Behavior methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
includes: behavior
	self == behavior ifTrue: [^true].
	methods == behavior ifTrue: [^true].
	^next notNil and: [next includes: behavior]
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instanceBehavior
	^self isInstanceBehavior ifTrue: [methods]
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
methods
	^methods
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
methods: aMethodDictionary
	methods := aMethodDictionary
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
next
	^next
! !

!Behavior methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
next: aBehavior
	next := aBehavior
! !

!Behavior methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replace: aBehavior with: newBehavior
	next == aBehavior
		ifTrue: [next := newBehavior]
		ifFalse: [next notNil ifTrue: [next replace: aBehavior with: newBehavior]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Behavior class' category: #Kernel!
Behavior class
	instanceVariableNames: ''!

!Behavior class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromClass: aClass
	^self new fromClass: aClass
! !

!Behavior class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^super new basicHash; yourself
! !

!Behavior class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: md
	^self new methods: md
! !

!Behavior class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: md1 with: md2
	^self new
		methods: md1;
		next: (self with: md2)
! !

!Behavior class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: md withAll: behavior
	^self new methods: md; next: behavior
! !


