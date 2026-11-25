'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ByteArraySegment category: #Kernel!
ArrayedCollection subclass: #ByteArraySegment
	instanceVariableNames: 'contents offset size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ByteArraySegment commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ByteArraySegment methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
= aCollection
	| index |
	self == aCollection ifTrue: [^true].
	self class == aCollection class ifFalse: [^false].
	index := self size.
	index !!= aCollection size ifTrue: [^false].
	[index <= 0] whileFalse: [
		(self at: index) = (aCollection at: index) ifFalse: [^false].
		index := index - 1].
	^true
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asByteArray
	^self copyFrom: 1 to: size
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asInteger
	^self inject: 0 into: [:sum :each | (sum bitShift: 8) + each]
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asParameter
	^self asByteArray asParameter
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asString
	| string n |
	n := self size.
	(n > 0 and: [(self at: n) = 0]) ifTrue: [n := n - 1].
	string := String new: n.
	^string replaceBytesFrom: 1 to: n with: self startingAt: 1
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: anInteger
	^self byteAt: anInteger
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: anInteger put: byte
	^self byteAt: anInteger put: byte
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
byteAt: index
	self validateIndex: index.
	^contents at: offset + index
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
byteAt: index put: byte
	self validateIndex: index.
	^contents at: offset + index put: byte
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
byteAtOffset: anInteger
	^self byteAt: anInteger + 1
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
byteAtOffset: anInteger put: byte
	^self byteAt: anInteger + 1 put: byte
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
bytesAtOffset: anInteger put: aByteArray
	self
		replaceFrom: anInteger + 1
		to: anInteger + aByteArray sizeInBytes
		with: aByteArray
		startingAt: 1
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyFrom: start to: end
	| s |
	self validateIndex: start toIndex: end.
	^contents copyFrom: offset + start to: offset + end
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
endOffset
	^offset + size
! !

!ByteArraySegment methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hash
	| hash |
	hash := size.
	offset + 1
		to: offset + size
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (contents at: i)].
	^hash
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
longAtOffset: anInteger
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	^contents longAtOffset: offset + anInteger
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
longAtOffset: anInteger put: long
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	contents longAtOffset: offset + anInteger put: long
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
offset
	^offset
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
offset: anInteger
	offset := anInteger
! !

!ByteArraySegment methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aByteArray from: start to: stop
	contents := aByteArray.
	offset := start - 1.
	size := stop - start + 1
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceBytesUpTo: count with: aCollection
	count > size ifTrue: [self validateIndex: count].
	self replaceFrom: 1 to: count with: aCollection
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceFrom: start to: end with: another
	^self replaceFrom: start to: end with: another startingAt: 1
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceFrom: start to: end with: another startingAt: index
	self validateIndex: start toIndex: end.
	^contents
		replaceFrom: offset + start
		to: offset + end
		with: another
		startingAt: index
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
segmentFrom: index size: anInteger
	^ByteArraySegment on: self from: index size: anInteger
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	^size
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
sizeInBytes
	^size
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
uLargeAtOffset: anInteger
	self validateIndex: anInteger + 1 toIndex: anInteger + 8.
	^contents uLargeAtOffset: offset + anInteger
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
uLargeAtOffset: anInteger put: ularge
	self validateIndex: anInteger + 1 toIndex: anInteger + 8.
	^contents uLargeAtOffset: offset + anInteger put: ularge
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
uLongAtOffset: anInteger
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	^contents uLongAtOffset: offset + anInteger
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
uLongAtOffset: anInteger put: long
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	contents uLongAtOffset: offset + anInteger put: long
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
uShortAtOffset: anInteger
	self validateIndex: anInteger + 1 toIndex: anInteger + 2.
	^contents uShortAtOffset: offset + anInteger
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
uShortAtOffset: anInteger put: long
	self validateIndex: anInteger + 1 toIndex: anInteger + 2.
	contents uShortAtOffset: offset + anInteger put: long
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
utf16
	^UTF16 current decode: self asByteArray
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
validateIndex: index
	(index between: 1 and: size) ifFalse: [self outOfBoundsIndex: index]
! !

!ByteArraySegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
validateIndex: start toIndex: end
	1 <= start ifFalse: [self outOfBoundsIndex: start].
	end <= size ifFalse: [self outOfBoundsIndex: end]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ByteArraySegment class' category: #Kernel!
ByteArraySegment class
	instanceVariableNames: ''!

!ByteArraySegment class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aByteArray from: start size: size
	^self on: aByteArray from: start to: start + size - 1
! !

!ByteArraySegment class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aByteArray from: start to: stop
	^self new on: aByteArray from: start to: stop
! !


