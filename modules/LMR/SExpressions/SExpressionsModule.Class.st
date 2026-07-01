'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SExpressionsModule category: #'Powerlang-Core-LMR'!
Module subclass: #SExpressionsModule
	instanceVariableNames: 'globals memory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-LMR'!
!SExpressionsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
	}
! !

!SExpressionsModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:39'!
justLoaded
	super justLoaded.
	TreecodeDecoder initializePools; initializeBindingTypes; initializeNodeTypes
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SExpressionsModule class' category: #'Powerlang-Core-LMR'!
SExpressionsModule class
	instanceVariableNames: ''!


