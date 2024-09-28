"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I represent Kernel DLL, the main library used in Windows applications.
"

Class {
	#name : #KernelDLL,
	#superclass : #ExternalLibrary,
	#category : #FFI
}
{ #category : #accessing }
KernelDLL class >> name [
	^'kernel32'
]

{ #category : #accessing }
KernelDLL >> LoadLibraryW: lpLibFileName [
	<cdecl: uintptr_t LoadLibrary (uintptr_t)>
]

{ #category : #accessing }
KernelDLL >> GetProcAddress: hModule lpProcName: lpProcName [
	<cdecl: uintptr_t GetProcAddress (uintptr_t, uintptr_t)>
]
