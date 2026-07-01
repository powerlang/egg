'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #WeakArray category: #Kernel!
Array subclass: #WeakArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!WeakArray commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeakArray class' category: #Kernel!
WeakArray class
	instanceVariableNames: ''!

!WeakArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	| array |
	array := super new: anInteger.
	array beWeak.
	^array
! !


