'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestLibrary category: #Tests!
ExternalLibrary subclass: #TestLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests'!
!TestLibrary commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
!

!TestLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addInt: anInteger toInt: anotherInteger
	<cdecl: pointer PaddPP(pointer, pointer)>
! !

!TestLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addDouble: aDouble toDouble: anotherDouble
	<cdecl: double DaddDD(double, double)>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestLibrary class' category: #Tests!
TestLibrary class
	instanceVariableNames: ''!

!TestLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
libname
	^'test'
! !

!TestLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
libpath
	^'./'
! !


