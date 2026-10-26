'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ArgParserModule category: #ArgParser!
Module subclass: #ArgParserModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArgParser'!
!ArgParserModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ArgParserModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(Error OrderedDictionary).
	}
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ArgParserModule class' category: #ArgParser!
ArgParserModule class
	instanceVariableNames: ''!


