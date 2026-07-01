'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #BeeTranscript category: #Kernel!
Object subclass: #BeeTranscript
	instanceVariableNames: 'out'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!BeeTranscript commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!BeeTranscript methodsFor:  'open/close' stamp: 'KenD 28/Jun/2026 13:27:38'!
close
! !

!BeeTranscript methodsFor:  'output' stamp: 'KenD 28/Jun/2026 13:27:38'!
cr
	self output: String cr
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BeeTranscript class' category: #Kernel!
BeeTranscript class
	instanceVariableNames: ''!


