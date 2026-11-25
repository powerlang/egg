'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #FFIDescriptor category: #FFI!
ArrayedCollection subclass: #FFIDescriptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!FFIDescriptor commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
argumentCount
	^self size - 2
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
argumentTypeAt: index
	^self at: index
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
argumentTypeAt: index put: typeInteger
	self at: index put: typeInteger
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
argumentTypes
	^(1 to: self argumentCount) collect: [:i | self argumentTypeAt: i]
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
argumentTypes: types
	types withIndexDo: [:code :i | self argumentTypeAt: i put: code]
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
callingConvention
	^self at: self size
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
callingConvention: ccCode
	self at: self size put: ccCode
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
returnType
	^self at: self size - 1
! !

!FFIDescriptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
returnType: anInteger
	self at: self size - 1 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FFIDescriptor class' category: #FFI!
FFIDescriptor class
	instanceVariableNames: ''!


