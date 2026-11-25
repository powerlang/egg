'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPMemento category: #PetitParser!
Object subclass: #PPMemento
	instanceVariableNames: 'result count position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PetitParser'!
!PPMemento commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPMemento methodsFor:  'accessing-readonly' stamp: 'KenD 28/Jun/2026 13:27:39'!
count
	^ count
! !

!PPMemento methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
increment
	count := count + 1
! !

!PPMemento methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	count := 0
	
! !

!PPMemento methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
position
	^ position
! !

!PPMemento methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
position: anInteger
	position := anInteger
! !

!PPMemento methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
result
	^ result
! !

!PPMemento methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
result: anObject
	result := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPMemento class' category: #PetitParser!
PPMemento class
	instanceVariableNames: ''!


PPMemento initialize!

