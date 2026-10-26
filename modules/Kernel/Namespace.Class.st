'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Namespace category: #Kernel!
Dictionary subclass: #Namespace
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Namespace commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022 Javier Pimás. 
    See (MIT) license in root directory.
!

!Namespace methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_namespaceLookup: aSymbol
	| table |
	table := namespace _basicAt: 2.
	2
		to: table _size
		do: [:j | | assoc |
			assoc := (table _basicAt: j).
			assoc == nil ifFalse: [
				assoc key == aSymbol
					ifTrue: [^table _basicAt: j + 1]]].
	^nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Namespace class' category: #Kernel!
Namespace class
	instanceVariableNames: ''!

!Namespace class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^super new
! !


