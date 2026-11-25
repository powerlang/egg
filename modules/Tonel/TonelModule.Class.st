'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TonelModule category: #Tonel!
Module subclass: #TonelModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tonel'!
!TonelModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:40'!
imports
	^{
		#STON -> #(#STONReader #STONWriter #STON).
		#Compiler -> #(#SSmalltalkParser).
		#Kernel -> #(#Module #OrderedDictionary #ReadStream)
	}
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TonelModule class' category: #Tonel!
TonelModule class
	instanceVariableNames: ''!


