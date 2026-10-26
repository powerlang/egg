'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #KernelDLL category: #FFI!
ExternalLibrary subclass: #KernelDLL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!KernelDLL commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I represent Kernel DLL, the main library used in Windows applications.
!

!KernelDLL methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
LoadLibraryW: lpLibFileName
	<cdecl: pointer LoadLibrary (pointer)>
! !

!KernelDLL methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
GetProcAddress: hModule lpProcName: lpProcName
	<cdecl: pointer GetProcAddress (pointer, pointer)>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'KernelDLL class' category: #FFI!
KernelDLL class
	instanceVariableNames: ''!

!KernelDLL class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name
	^'kernel32'
! !


