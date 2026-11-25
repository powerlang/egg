'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ExternalHandle category: #FFI!
ByteArray subclass: #ExternalHandle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!ExternalHandle commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
!

!ExternalHandle methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
asInteger
	^self pointerAtOffset: 0
! !

!ExternalHandle methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isValid
	^self asInteger !!= 0
! !

!ExternalHandle methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	^self requireFinalization
! !

!ExternalHandle methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
release
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExternalHandle class' category: #FFI!
ExternalHandle class
	instanceVariableNames: ''!

!ExternalHandle class methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
new
	^self new: WordSize
! !


ExternalHandle initialize!

