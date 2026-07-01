'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestsModule category: #Test!
Module subclass: #TestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Test'!
!TestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(Error).
		#SUnit -> #(SUnitNameResolver TestCase TestResource TestResult TestSuite)
	}
! !

!TestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	super initialize
! !

!TestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
main: args
	| result |
	Kernel log: 'running tests...', String cr.

	result := SUnitTest buildTestSuite run.
	Kernel log: 'done', String cr.
	Kernel log: 'Results: ', String cr.
	Kernel log: result printString, String cr, String cr.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestsModule class' category: #Test!
TestsModule class
	instanceVariableNames: ''!


TestsModule initialize!

