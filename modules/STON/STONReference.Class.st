'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STONReference category: #STON!
Object subclass: #STONReference
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'STON'!
!STONReference commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!STONReference methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
= anObject
	^self class == anObject class and: [self index = anObject index]
! !

!STONReference methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hash
	^index hash
! !

!STONReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index
	^index
! !

!STONReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: integer
	index := integer
! !

!STONReference methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStonReference
	^true
! !

!STONReference methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: stream
	super printOn: stream.
	stream nextPut: $(; print: index; nextPut: $)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STONReference class' category: #STON!
STONReference class
	instanceVariableNames: ''!

!STONReference class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
index: integer
	^self new index: integer
! !


