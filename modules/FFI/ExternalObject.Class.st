'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ExternalObject category: #FFI!
Object subclass: #ExternalObject
	instanceVariableNames: 'handle'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!ExternalObject commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
!

!ExternalObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
asParameter
	^handle
! !

!ExternalObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
handle
	^handle
! !

!ExternalObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
handle: anObject
	handle := anObject
! !

!ExternalObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isValid
	^handle notNil
! !

!ExternalObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	self requireFinalization
! !

!ExternalObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
release
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExternalObject class' category: #FFI!
ExternalObject class
	instanceVariableNames: ''!


ExternalObject initialize!

