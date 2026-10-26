'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Array category: #Kernel!
ArrayedCollection subclass: #Array
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Array commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Array methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asArray
	^self
! !

!Array methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asByteArray
	^ByteArray withAll: self
! !

!Array methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBePrintedAsLiteral
	^Recursion
		checkOn: self
		while: [self conform: [:each | each canBePrintedAsLiteral]]
		onSignal: [false]
! !

!Array methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
crash
	| t |
	t := 1.
	self do: [:each | | n |
		n := self size + each + t.
		(1 to: n) do: [:i | i]].
	^self size
! !

!Array methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isArray
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Array class' category: #Kernel!
Array class
	instanceVariableNames: ''!


