'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #RelocationFixup category: #'Powerlang-Core-Assembly'!
Object subclass: #RelocationFixup
	instanceVariableNames: 'source target relative size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!RelocationFixup commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!RelocationFixup methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
addressSize
	^4
! !

!RelocationFixup methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beAbsolute
	relative := false.
	size := self addressSize
! !

!RelocationFixup methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beRelative
	relative := true
! !

!RelocationFixup methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: address1 to: address2
	source := address1.
	target := address2
! !

!RelocationFixup methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isRelative
	^relative
! !

!RelocationFixup methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
patch: buffer with: solver
	| delta address |
	address := solver resolveLabel: target.
	self ASSERT: address notNil.
	relative
		ifTrue: [
			delta := address - source - size.
			size = 1
				ifTrue: [buffer writeByte: delta at: source]
				ifFalse: [buffer writeLong: delta at: source]]
		ifFalse: [buffer writeLong: address at: source]
! !

!RelocationFixup methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	aStream
		nextPutAll: self class name;
		nextPut: $:;
		space;
		nextPutAll: target printString
! !

!RelocationFixup methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
relocateBy: delta
	source := source + delta
! !

!RelocationFixup methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
size: anInteger
	size := anInteger
! !

!RelocationFixup methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
target
	^target
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RelocationFixup class' category: #'Powerlang-Core-Assembly'!
RelocationFixup class
	instanceVariableNames: ''!

!RelocationFixup class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
absoluteFrom: source to: target
	^self new beAbsolute; from: source to: target
! !

!RelocationFixup class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
relativeFrom: source to: target
	^self new beRelative; from: source to: target
! !


