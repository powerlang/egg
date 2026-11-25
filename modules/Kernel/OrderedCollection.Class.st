'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #OrderedCollection category: #Kernel!
SequenceableCollection subclass: #OrderedCollection
	instanceVariableNames: 'start end contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!OrderedCollection commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!OrderedCollection methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
, aCollection
	aCollection isCollection ifFalse: [super , aCollection].
	^self copy addAll: aCollection; yourself
! !

!OrderedCollection methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
absentElement
	^self error: 'element not found'
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject
	^self basicAdd: anObject
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject after: anotherObject
	| index |
	index := self indexOf: anotherObject ifAbsent: [^self absentElement].
	^self add: anObject afterIndex: index
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject afterIndex: anInteger
	self makeRoomBehind: anInteger.
	^self at: anInteger + 1 put: anObject
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject at: anInteger
	self makeRoomBehind: anInteger - 1.
	^contents at: start + anInteger - 1 put: anObject
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject before: anotherObject
	| index |
	index := self indexOf: anotherObject ifAbsent: [^self absentElement].
	^self add: anObject beforeIndex: index
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject beforeIndex: anInteger
	self makeRoomBehind: anInteger - 1.
	^self at: anInteger put: anObject
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAll: aCollection
	^aCollection isSequenceableCollection
		ifTrue: [self addAllLast: aCollection]
		ifFalse: [super addAll: aCollection]
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAllFirst: aCollection
	| pending n |
	pending := aCollection size.
	[| free |
		free := start - 1.
		(pending > 0 and: [free = 0]) ifTrue: [
			self makeRoomBefore.
			free := start - 1].
		n := free min: pending.
		n > 0]
		whileTrue: [
			contents
				replaceFrom: start - n
				to: start - 1
				with: aCollection
				startingAt: pending - n + 1.
			start := start - n.
			pending := pending - n].
	^aCollection
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAllLast: aCollection
	| index m n |
	index := 1.
	m := aCollection size.
	[| free pending |
		pending := m - index + 1.
		free := contents size - end.
		(pending > 0 and: [free = 0]) ifTrue: [
			start > 1 ifTrue: [self compact] ifFalse: [self grow].
			free := contents size - self size].
		n := free min: pending.
		n > 0]
		whileTrue: [
			contents
				replaceFrom: end + 1
				to: end + n
				with: aCollection
				startingAt: index.
			end := end + n.
			index := index + n].
	^aCollection
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addFirst: anObject
	start = 1 ifTrue: [self makeRoomBefore].
	start := start - 1.
	contents at: start put: anObject.
	^anObject
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addLast: anObject
	^self basicAdd: anObject
! !

!OrderedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
allButIndex: anInteger
	^self copy removeIndex: anInteger
! !

!OrderedCollection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asOrderedCollection
	^self
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger
	^self at: anInteger ifAbsent: [self outOfBoundsIndex: anInteger]
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger ifAbsent: aBlock
	| index |
	index := anInteger + start - 1.
	(start <= index and: [index <= end]) ifFalse: [^aBlock value].
	^contents at: index
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: anObject
	| index |
	index := anInteger + start - 1.
	(start <= index and: [index <= end])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^contents at: index put: anObject
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atAllPut: anObject
	start to: end do: [:i | contents at: i put: anObject]
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: anInteger
	^contents at: anInteger + start - 1
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAdd: anObject
	end = contents size ifTrue: [self makeRoomBehind].
	end := end + 1.
	contents at: end put: anObject.
	^anObject
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectionSize
	^end - start + 1
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
compact
	| size e |
	start = 1 ifTrue: [^self].
	size := self size.
	e := end.
	contents
		replaceFrom: 1
		to: size
		with: contents
		startingAt: start.
	start := 1.
	end := size.
	contents replaceFrom: end + 1 to: e withObject: nil
! !

!OrderedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyFrom: startIndex to: endIndex
	| n copy |
	n := endIndex - startIndex + 1 max: 0.
	copy := self species new: self size.
	copy stretchTo: n.
	^copy replaceFrom: 1 to: n with: self startingAt: startIndex
! !

!OrderedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyWith: anObject
	^self copy add: anObject; yourself
! !

!OrderedCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	start to: end do: [:i | aBlock evaluateWith: (contents at: i)]
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
grow
	self growTo: contents size + self growSize
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
growTo: anInteger
	| copy |
	copy := contents class new: anInteger.
	copy
		replaceFrom: start
		to: end
		with: contents
		startingAt: start.
	contents := copy
! !

!OrderedCollection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
includes: anObject
	start to: end do: [:i | anObject = (contents at: i) ifTrue: [^true]].
	^false
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize: anInteger
	start := 1.
	end := 0.
	contents := Array new: anInteger
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
makeRoomBefore
	| n s |
	n := self collectionSize.
	end := end = contents size
		ifTrue: [
			self grow.
			contents size + end + 1 // 2]
		ifFalse: [contents size].
	s := start.
	start := end - n + 1.
	contents
		replaceFrom: start
		to: end
		with: contents
		startingAt: s;
		replaceFrom: s to: start - 1 withObject: nil
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
makeRoomBehind
	| s n e |
	start = 1 ifTrue: [^self grow].
	s := start // 2.
	n := self collectionSize.
	e := end.
	end := s + n - 1.
	contents
		replaceFrom: s
		to: end
		with: contents
		startingAt: start;
		replaceFrom: end + 1 to: e withObject: nil.
	start := s
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
makeRoomBehind: anInteger
	(anInteger = 0 and: [start > 1]) ifTrue: [
		start := start - 1.
		^self].
	end = contents size ifTrue: [self makeRoomBehind].
	end := end + 1.
	contents
		replaceFrom: start + anInteger + 1
		to: end
		with: contents
		startingAt: start + anInteger
! !

!OrderedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
pop
	^self removeLast
! !

!OrderedCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	contents := contents copy
! !

!OrderedCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
push: anObject
	^self add: anObject
! !

!OrderedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject ifAbsent: aBlock
	start to: end do: [:i | 
		anObject = (contents at: i) ifTrue: [
			self removeIndex: i - start + 1.
			^anObject]].
	^aBlock value
! !

!OrderedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll
	contents replaceFrom: start to: end withObject: nil.
	start := 1.
	end := 0
! !

!OrderedCollection methodsFor:  'adding/removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAllSuchThat: aBlock
	| n |
	n := start.
	start to: end do: [:index | | element |
		element := contents at: index.
		(aBlock value: element) ifFalse: [
			contents at: n put: element.
			n := n + 1]].
	contents replaceFrom: n to: end withObject: nil.
	end := n - 1.
	end < start ifTrue: [
		start := 1.
		end := 0]
! !

!OrderedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeFirst
	| first |
	start > end ifTrue: [^self absentElement].
	first := contents at: start.
	contents at: start put: nil.
	start := start + 1.
	end < start ifTrue: [
		start := 1.
		end := 0].
	^first
! !

!OrderedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeIndex: anInteger
	| absolute |
	absolute := anInteger + start - 1.
	(absolute between: start and: end) ifFalse: [^self absentElement].
	absolute <= (start + end // 2)
		ifTrue: [
			contents
				replaceFrom: start + 1 to: absolute with: contents startingAt: start;
				at: start put: nil.
			start := start + 1]
		ifFalse: [
			contents
				replaceFrom: absolute
				to: end - 1
				with: contents
				startingAt: absolute + 1;
				at: end put: nil.
			end := end - 1].
	end < start ifTrue: [
		start := 1.
		end := 0]
! !

!OrderedCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeLast
	| last |
	start > end ifTrue: [^self absentElement].
	last := contents at: end.
	contents at: end put: nil.
	end := end - 1.
	end < start ifTrue: [
		start := 1.
		end := 0].
	^last
! !

!OrderedCollection methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceBackwardFrom: first to: last with: aCollection startingAt: position
	contents
		replaceBackwardFrom: start + first - 1
		to: start + last - 1
		with: aCollection
		startingAt: position
! !

!OrderedCollection methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceForwardFrom: first to: last with: aCollection startingAt: position
	contents
		replaceForwardFrom: start + first - 1
		to: start + last - 1
		with: aCollection
		startingAt: position
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: firstIndex to: lastIndex with: aCollection
	| m d n e |
	m := aCollection size.
	d := lastIndex - firstIndex + 1.
	n := self size - d + m.
	n > contents size ifTrue: [self growTo: n // 2 + n].
	e := end.
	end := contents size.
	self
		replaceFrom: firstIndex + m to: n with: self startingAt: lastIndex + 1;
		replaceFrom: firstIndex
		to: firstIndex + m - 1
		with: aCollection
		startingAt: 1.
	end := start + n - 1.
	contents replaceFrom: e + m - d + 1 to: e withObject: nil
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^self collectionSize
! !

!OrderedCollection methodsFor:  'sorting' stamp: 'KenD 28/Jun/2026 13:27:38'!
sortBy: aBlock
	contents sort: start to: end with: aBlock
! !

!OrderedCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
stretchTo: n
	n < end ifTrue: [self error: 'invalid argument'].
	end := n + start - 1
! !

!OrderedCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
stretchToContents
	start := 1.
	end := contents size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OrderedCollection class' category: #Kernel!
OrderedCollection class
	instanceVariableNames: ''!

!OrderedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
from: anObject iterator: aSymbol
	| new |
	new := self new.
	anObject perform: aSymbol with: [:element | new add: element].
	^new
! !

!OrderedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self new: 10
! !

!OrderedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self basicNew initialize: anInteger
! !

!OrderedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: size withAll: anObject
	| instance |
	instance := self new: size.
	instance stretchToContents.
	anObject notNil ifTrue: [instance atAllPut: anObject].
	^instance
! !

!OrderedCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: aCollection
	| collection |
	collection := self new: aCollection size.
	collection addAll: aCollection.
	^collection
! !


