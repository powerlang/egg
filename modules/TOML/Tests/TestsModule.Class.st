'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestsModule category: #'TOML.Tests'!
Module subclass: #TestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TOML.Tests'!
!TestsModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!TestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(Error OrderedDictionary).
		#TOML -> #(TOMLParser).
		#SUnit -> #(TestCase TestResult)
	}
! !

!TestsModule methodsFor:  'main' stamp: 'KenD 28/Jun/2026 13:27:37'!
main: anArray
	| suite result |
	Kernel log: 'Running TOML tests...
'.
	suite := TOMLParserTest buildTestSuite.
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

!classDefinition: 'TestsModule class' category: #'TOML.Tests'!
TestsModule class
	instanceVariableNames: ''!


