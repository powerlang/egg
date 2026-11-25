'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #CallbackMethod category: #FFI!
CompiledMethod subclass: #CallbackMethod
	instanceVariableNames: 'receiver descriptor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!CallbackMethod commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!CallbackMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
descriptor
	^descriptor
! !

!CallbackMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
descriptor: anFFIDescriptor
	descriptor := anFFIDescriptor
! !

!CallbackMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isCallback
	^true
! !

!CallbackMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
receiver
	^receiver
! !

!CallbackMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
receiver: anObject
	receiver := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallbackMethod class' category: #FFI!
CallbackMethod class
	instanceVariableNames: ''!


