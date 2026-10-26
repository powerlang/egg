'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ObjectReference category: #Kernel!
Object subclass: #ObjectReference
	instanceVariableNames: 'source sourceOffset target absolute'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ObjectReference commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ObjectReference methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:38'!
beAbsolute
	absolute := true
! !

!ObjectReference methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:38'!
classBinding
	^source classBinding
! !

!ObjectReference methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
for: anObject
	self target: anObject
! !

!ObjectReference methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	absolute := false
! !

!ObjectReference methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isAbsolute
	^absolute
! !

!ObjectReference methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMethod
	^false
! !

!ObjectReference methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: 'Ref to ' , target printString
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
source: sourceObject
	source := sourceObject
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sourceOffset
	^sourceOffset
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sourceOffset: aNumber
	sourceOffset := aNumber
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
target
	^target
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
target: anObject
	target := anObject
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
targetOffset
	^0
! !

!ObjectReference methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueToWriteAt: sourceAddress targeting: targetAddress with: wordSize
	| address correction |
	address := targetAddress + self targetOffset.
	correction := absolute
		ifTrue: [0]
		ifFalse: [sourceAddress + sourceOffset + wordSize].
	^address - correction
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueToWriteAt: sourceAddress with: wordSize
	^self
		valueToWriteAt: sourceAddress
		targeting: target _asSmallInteger
		with: wordSize
! !

!ObjectReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueToWriteWith: wordSize
	^self valueToWriteAt: source _asSmallInteger + sourceOffset with: wordSize
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ObjectReference class' category: #Kernel!
ObjectReference class
	instanceVariableNames: ''!

!ObjectReference class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
absoluteFor: anObject
	^(self new for: anObject) beAbsolute
! !


ObjectReference initialize!

