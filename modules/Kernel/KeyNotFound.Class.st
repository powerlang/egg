'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #KeyNotFound category: #Kernel!
Error subclass: #KeyNotFound
	instanceVariableNames: 'object'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!KeyNotFound commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!KeyNotFound methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultDescription
	| string |
	string := [object printString] on: Error do: [:ex | ex description].
	^'Key ' , string , ' is missing'
! !

!KeyNotFound methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
object: anObject
	object := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'KeyNotFound class' category: #Kernel!
KeyNotFound class
	instanceVariableNames: ''!

!KeyNotFound class methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalFor: anObject
	^self new object: anObject; signal
! !


