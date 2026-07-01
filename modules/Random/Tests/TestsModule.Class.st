'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestsModule category: #'Random.Tests'!
Module subclass: #TestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Random.Tests'!
!TestsModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!TestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(Float).
		#Random -> #(Random).
		#SUnit -> #(TestCase TestResult)
	}
! !

!TestsModule methodsFor:  'main' stamp: 'KenD 28/Jun/2026 13:27:37'!
main: anArray
	| suite result |
	Kernel log: 'Running Random tests...
'.
	suite := RandomTest buildTestSuite.
	Kernel log: 'suite built with ', suite tests size printString, ' tests
'.
	result := suite run.
	Kernel log: 'Done.
'.
	Kernel log: result printString.
	Kernel log: '
'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestsModule class' category: #'Random.Tests'!
TestsModule class
	instanceVariableNames: ''!


