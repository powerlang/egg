'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ProcessStackChunk category: #Kernel!
Object subclass: #ProcessStackChunk
	instanceVariableNames: 'sp bp base prev defaultReturn'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ProcessStackChunk commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
!

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
base
	^base
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
base: anInteger
	base := anInteger
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bp
	^bp
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bp: anInteger
	bp := anInteger
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultReturn
	^defaultReturn
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultReturn: anInteger
	defaultReturn := anInteger
! !

!ProcessStackChunk methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	defaultReturn := 0
! !

!ProcessStackChunk methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
invalidate
	sp := bp := nil
! !

!ProcessStackChunk methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
isForCallback
	^prev notNil
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
prev
	^prev
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
prev: aProcessStackChunk
	prev := aProcessStackChunk
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
relocate: anInteger
	sp ifNotNil: [
		sp := sp + anInteger.
		bp := bp + anInteger].
	base := base + anInteger
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sp
	^sp
! !

!ProcessStackChunk methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sp: anInteger
	sp := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ProcessStackChunk class' category: #Kernel!
ProcessStackChunk class
	instanceVariableNames: ''!

!ProcessStackChunk class methodsFor:  'instance-creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
after: aProcessStackChunk
	^self new prev: aProcessStackChunk
! !


ProcessStackChunk initialize!

