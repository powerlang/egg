'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #LoaderModule category: #Tonel!
Module subclass: #LoaderModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tonel'!
!LoaderModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
!

!LoaderModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:40'!
imports
	^{
		#Kernel -> #(IdentitySet Module).
		#Compiler -> #SCompiler
	}
! !

!LoaderModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:40'!
start

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LoaderModule class' category: #Tonel!
LoaderModule class
	instanceVariableNames: ''!


