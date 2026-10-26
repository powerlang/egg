'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #JSONModule category: #'Powerlang-Core-Modules-JSON'!
Module subclass: #JSONModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Modules-JSON'!
!JSONModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#Kernel -> #(Module HashTable IdentityDictionary).
		#ImageSegmentBuilder -> #Writer
	}
! !

!JSONModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	self name: #'ImageSegmentBuilder.JSON'
! !

!JSONModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
newWriter
	^JSONWriter new
! !

!JSONModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
fileExtension
	^'json'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JSONModule class' category: #'Powerlang-Core-Modules-JSON'!
JSONModule class
	instanceVariableNames: ''!


JSONModule initialize!

