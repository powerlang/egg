'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Time category: #Kernel!
Magnitude subclass: #Time
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Time commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Time class' category: #Kernel!
Time class
	instanceVariableNames: ''!

!Time class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
millisecondsToRun: aClosure
	| start stop |
	start := Kernel host currentMilliseconds.
	aClosure value.
	stop := Kernel host currentMilliseconds.
	^stop - start
! !


