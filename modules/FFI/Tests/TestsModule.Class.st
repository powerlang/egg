'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestsModule category: #Tests!
Module subclass: #TestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests'!
!TestsModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!TestsModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(WordSize).
		#FFI -> #(ExternalLibrary)
	}
! !

!TestsModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
main: args
	| test result |
	ExternalLibrary module initializeForCurrentPlatform.

	test := TestLibrary new open.
	result := test addInt: 3 toInt: 4.
	result = 7 ifFalse: [self error: 'addInt:toInt: failed!!'].
	result := test addDouble: 3.0 toDouble: 4.0.
	result = 7.0 ifFalse: [self error: 'addDouble:toDouble: failed!!'].
	Kernel log: 'all FFI tests passed!!'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestsModule class' category: #Tests!
TestsModule class
	instanceVariableNames: ''!


