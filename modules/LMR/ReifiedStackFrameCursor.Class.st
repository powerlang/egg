'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ReifiedStackFrameCursor category: #Kernel!
StackFrameCursor subclass: #ReifiedStackFrameCursor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ReifiedStackFrameCursor commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ReifiedStackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addObjectsTo: aCollection
	self slotCount to: 1 by: -1 do: [:i | aCollection add: (self slotAt: i)]
! !

!ReifiedStackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
caller
	^current + ((current _asObject _basicAt: 1) // 2)
! !

!ReifiedStackFrameCursor methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
ended
	^current == previous
! !

!ReifiedStackFrameCursor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsDo: aBlock
	self slotCount to: 1 by: -1 do: [:i | aBlock value: (self slotAt: i)]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReifiedStackFrameCursor class' category: #Kernel!
ReifiedStackFrameCursor class
	instanceVariableNames: ''!


