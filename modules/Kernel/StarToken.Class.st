'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #StarToken category: #Kernel!
Object subclass: #StarToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!StarToken commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!StarToken methodsFor:  'double dispatching' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchFirstAfterStartOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstStar
! !

!StarToken methodsFor:  'double dispatching' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchFirstOn: aMatchAlgorithm
	aMatchAlgorithm matchFirstStar
! !

!StarToken methodsFor:  'double dispatching' stamp: 'KenD 28/Jun/2026 13:27:38'!
matchLastOn: aMatchAlgorithm
	"
	do nothing
	"
	
! !

!StarToken methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPut: $*
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StarToken class' category: #Kernel!
StarToken class
	instanceVariableNames: ''!

!StarToken class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
current
	^current
! !

!StarToken class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeCurrent
	current := self new
! !


