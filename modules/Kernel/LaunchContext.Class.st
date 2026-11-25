'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LaunchContext category: #Kernel!
Context subclass: #LaunchContext
	instanceVariableNames: 'arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!LaunchContext commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
!

!LaunchContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arguments
	^arguments
! !

!LaunchContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arguments: anArray
	arguments := anArray
! !

!LaunchContext methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyAllTo: aProcessStack
	| index base |
	index := aProcessStack bufferSize.
	arguments do: [:arg |
		aProcessStack at: index put: arg.
		index := index - 1].

	base := index - 1.
	aProcessStack
		pcAt: index put: 0 of: nil;
		bpAt: base put: 0.

	^self copyTo: aProcessStack at: index - 2
! !

!LaunchContext methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
previousEnvironment
	^nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LaunchContext class' category: #Kernel!
LaunchContext class
	instanceVariableNames: ''!


