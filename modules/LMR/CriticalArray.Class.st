'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #CriticalArray category: #Kernel!
SequenceableCollection subclass: #CriticalArray
	instanceVariableNames: 'size contents allocator writeBarrier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!CriticalArray commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!CriticalArray methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
add: object
	size = contents _size ifTrue: [self grow].
	size := size + 1.
	self at: size put: object
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocator
	^allocator
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocator: anAllocator
	allocator := anAllocator
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: index
	^contents _basicAt: index
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: index put: anObject
	^writeBarrier
		ifTrue: [contents objectAtValid: index put: anObject]
		ifFalse: [contents _basicAt: index put: anObject]
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
contents
	^contents
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
contents: collection
	contents := collection
! !

!CriticalArray methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
do: aBlock
	1 to: self size do: [:index | | element |
		element := self at: index.
		aBlock value: element]
! !

!CriticalArray methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
grow
	self growTo: contents _size * 2
! !

!CriticalArray methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
growTo: n
	| expanded |
	contents _size >= n ifTrue: [^self].
	expanded := allocator shallowCopy: contents growingTo: n.
	expanded ifNil: [self _error: 'Could not copy critical array contents'].
	contents := expanded
! !

!CriticalArray methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
ignoreWriteBarrier
	writeBarrier := false
! !

!CriticalArray methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
includes: anObject
	1 to: size do: [:i | anObject = (contents at: i) ifTrue: [^true]].
	^false
! !

!CriticalArray methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
includesIdentical: anObject
	1 to: size do: [:i | anObject == (contents at: i) ifTrue: [^true]].
	^false
! !

!CriticalArray methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	size := 0.
	writeBarrier := true.
	contents := #().
	allocator := Allocator new memory: Memory current
! !

!CriticalArray methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEmpty
	^size = 0
! !

!CriticalArray methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
pop
	| answer |
	answer := self at: size.
	contents _basicAt: size put: nil.
	size := size - 1.
	^answer
! !

!CriticalArray methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
postCopy
	super postCopy.
	contents := contents copy
! !

!CriticalArray methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
push: object
	^self add: object
! !

!CriticalArray methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
remove: anObject ifAbsent: aBlock
	1 to: size do: [:i | 
		anObject == (contents at: i) ifTrue: [
			self removeIndex: i.
			^anObject]].
	^aBlock value
! !

!CriticalArray methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeIndex: anInteger
	contents
		replaceFrom: anInteger
		to: size - 1
		with: contents
		startingAt: anInteger + 1;
		at: size put: nil.
	size := size - 1
! !

!CriticalArray methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset
	1 to: self size do: [:i | contents _basicAt: i put: nil].
	size := 0
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	^size
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
size: anInteger
	size := anInteger
! !

!CriticalArray methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:39'!
unsafeAdd: anObject
	size = contents _size ifTrue: [self grow].
	size := size + 1.
	self unsafeAt: size put: anObject
! !

!CriticalArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
unsafeAt: index put: anObject
	^contents _basicAt: index put: anObject
! !

!CriticalArray methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
usePinnedAllocation
	allocator := PinnedAllocator new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CriticalArray class' category: #Kernel!
CriticalArray class
	instanceVariableNames: ''!


CriticalArray initialize!

