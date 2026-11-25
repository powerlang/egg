'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NativeModule category: #'Powerlang-Core-LMR'!
Module subclass: #NativeModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-LMR'!
!NativeModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2023-2024, Javier Pimás.
    See (MIT) license in root directory.

	This module implements a writer that serializes Egg objects into a stream in a format that is
	very similar to the format of objects in raw memory. Egg object format is decribed in detail
	in Egg documentation.
!

!NativeModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#Kernel -> #(Module HashTable IdentityDictionary ProtoObject).
		#ImageSegmentBuilder -> #Writer
	}
! !

!NativeModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	| names |
	super initialize.
	names := (ProtoObject classVarNamed: #ObjectBitsMasks).
	names ifNil: [self _halt].
	NativeWriter addNamespace: names.
! !

!NativeModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
newWriter
	^NativeWriter new
! !

!NativeModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
fileExtension
	"Egg Module Snapshot"
	^'ems'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativeModule class' category: #'Powerlang-Core-LMR'!
NativeModule class
	instanceVariableNames: ''!


NativeModule initialize!

