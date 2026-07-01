'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TestsModule category: #'Tonel.Tests'!
Module subclass: #TestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tonel.Tests'!
!TestsModule commentStamp: '<historical>' prior: 0!

	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
!

!TestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:40'!
imports
	^{
		#Kernel -> #(OrderedDictionary Error).
		#Tonel -> #(TonelWriter TonelReader).
		#SUnit -> #(TestCase TestSuite TestResult TestFailure)
	}
! !

!TestsModule methodsFor:  'main' stamp: 'KenD 28/Jun/2026 13:27:40'!
main: anArray
	| result |
	Kernel log: 'Running ', self name, ' tests...'; log: String cr.
	result := (TestSuite forModule: self) run.
	Kernel
		log: 'Done: ', result passedCount printString, ' passed, ',
			(result failureCount + result errorCount) printString, ' failed.';
		log: String cr
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestsModule class' category: #'Tonel.Tests'!
TestsModule class
	instanceVariableNames: ''!


