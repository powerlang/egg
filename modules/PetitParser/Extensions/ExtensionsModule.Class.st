'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ExtensionsModule category: #PetitParser!
Module subclass: #ExtensionsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PetitParser'!
!ExtensionsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#Kernel -> #(#CharacterArray #Closure #ReadStream #SequenceableCollection #Symbol #UndefinedObject)
	}
! !

!ExtensionsModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	self name: #'PetitParser.Extensions'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtensionsModule class' category: #PetitParser!
ExtensionsModule class
	instanceVariableNames: ''!


ExtensionsModule initialize!

