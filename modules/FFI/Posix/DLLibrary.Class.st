'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #DLLibrary category: #FFI!
ExternalLibrary subclass: #DLLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!DLLibrary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I represent dl, the library used in linux to dynamically load other libraries.
!

!DLLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
dlerror
	<cdecl: pointer dlerror ()>
! !

!DLLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
dlopen: filename flags: flags
	<cdecl: pointer dlopen (pointer, sint)>
! !

!DLLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
dlsym: handle symbol: functionName
	<cdecl: pointer dlsym (pointer, pointer)>
! !

!DLLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
lastError
	| address cstring |
	address := self dlerror.
	address = 0 ifTrue: [self error: 'no error message when a dlerror was expected'].
	cstring := ExternalMemory at: address.
	String fromMemory: cstring
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DLLibrary class' category: #FFI!
DLLibrary class
	instanceVariableNames: ''!


