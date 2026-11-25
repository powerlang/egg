'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonModule category: #JSON!
Module subclass: #JsonModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:41'!
imports
	^{
		#Kernel -> #(Character Error IdentitySet OrderedDictionary).
	}
! !

!JsonModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:41'!
justLoaded
	JsonWriter initializePools
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonModule class' category: #JSON!
JsonModule class
	instanceVariableNames: ''!


