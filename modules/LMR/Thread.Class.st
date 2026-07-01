'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Thread category: #Kernel!
Object subclass: #Thread
	instanceVariableNames: ''
	classVariableNames: 'tlsGlobalDispatchCacheIndex'
	poolDictionaries: ''
	category: 'Kernel'!
!Thread commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Thread class' category: #Kernel!
Thread class
	instanceVariableNames: 'tlsGlobalDispatchCacheIndex'!

!Thread class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
currentGlobalLookup
	^tlsGlobalDispatchCacheIndex _getThreadValue
! !


