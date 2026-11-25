'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ABI category: #'Nativization-Assembly'!
Object subclass: #ABI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization-Assembly'!
!ABI commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.

`ABI` seems to serve two different purposes:

 i) provide support for calling (native) function with system
	calling convention for given architecture and OS combination

ii) provide fixed mapping from 'IR' registers (such as A, R, M and so on)
	to real machine registers

!

!ABI methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
is32bits
	^self bits = 32
! !

!ABI methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
is64bits
	^self bits = 64
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regE
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFP
	^ self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFalse
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regG
	^ self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regIP
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regM
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regNil
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regS
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regSP
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regTrue
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regV
	^self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX0
	^ self subclassResponsibility
! !

!ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX1
	^ self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ABI class' category: #'Nativization-Assembly'!
ABI class
	instanceVariableNames: ''!


