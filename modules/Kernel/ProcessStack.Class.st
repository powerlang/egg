'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ProcessStack category: #Kernel!
Object subclass: #ProcessStack
	instanceVariableNames: 'process sp bp env'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ProcessStack commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
!

!ProcessStack methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
lastArgumentOf: frame
	"
		Given the base index of a frame, then comes retaddr, then last argument passed in the invokation
	"
	^self at: frame + 2
! !

!ProcessStack methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
contextSwitchTo: next
	self subclassResponsibility
! !

!ProcessStack methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
fillFrom: aContext
	#CRITICAL.
	sp := aContext copyAllTo: self.
	env := aContext lastEnvironment
! !

!ProcessStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
env
	^env
! !

!ProcessStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
env: anObject
	env := anObject
! !

!ProcessStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
process
	^process
! !

!ProcessStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
process: aProcess
	process := aProcess
! !

!ProcessStack methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
snapshot
	self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ProcessStack class' category: #Kernel!
ProcessStack class
	instanceVariableNames: ''!

!ProcessStack class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aProcess
	^self errorVMSpecific
! !


