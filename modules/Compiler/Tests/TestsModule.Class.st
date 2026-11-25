'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #TestsModule category: #'Compiler.Tests'!
Module subclass: #TestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Compiler.Tests'!
!TestsModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!TestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:41'!
imports
	^{
		#Kernel -> #(Array Error Exception OrderedCollection UndefinedObject WideString WideSymbol).
		#Compiler -> #(SCompiler SCompilationError SMethodNode SSelectorNode SMessageNode SStringToken InlinedArgEnvironment MethodScope).
		#SUnit -> #(TestCase TestResult TestSuite)
	}
! !

!TestsModule methodsFor:  'main' stamp: 'KenD 28/Jun/2026 13:27:41'!
main: anArray
	| suite result |
	Kernel log: 'Running Compiler tests...
'.
	suite := TestSuite forModule: self.
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

!classDefinition: 'TestsModule class' category: #'Compiler.Tests'!
TestsModule class
	instanceVariableNames: ''!


