'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #HelloWorldModule category: #'Examples-HelloWorld'!
Module subclass: #HelloWorldModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Examples-HelloWorld'!
!HelloWorldModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{}
! !

!HelloWorldModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
main: arguments
	Kernel log: 'Hello, World!!', String cr.
	^0
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HelloWorldModule class' category: #'Examples-HelloWorld'!
HelloWorldModule class
	instanceVariableNames: ''!


