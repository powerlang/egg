'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #FFIMethod category: #FFI!
CompiledMethod subclass: #FFIMethod
	instanceVariableNames: 'descriptor symbol address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!FFIMethod commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!FFIMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
address
	^address
! !

!FFIMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
address: anInteger
	address := anInteger
! !

!FFIMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
descriptor
	^descriptor
! !

!FFIMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
descriptor: anFFIDescriptor
	descriptor := anFFIDescriptor
! !

!FFIMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
descriptorBytes: aByteArray
	descriptor := FFIDescriptor withAll: aByteArray
! !

!FFIMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
symbol
	^symbol
! !

!FFIMethod methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
symbol: aString
	symbol := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FFIMethod class' category: #FFI!
FFIMethod class
	instanceVariableNames: ''!


