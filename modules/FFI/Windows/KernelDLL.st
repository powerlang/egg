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
KernelDLL class >> libname [
	^'kernel32'
]

{ #category : #accessing }
KernelDLL >> LoadLibraryW: lpLibFileName [
	<cdecl: pointer LoadLibraryW (pointer)>
]

{ #category : #accessing }
KernelDLL >> GetProcAddress: hModule lpProcName: lpProcName [
	<cdecl: pointer GetProcAddress (pointer, pointer)>
]

{ #category : #memory }
KernelDLL >> VirtualAlloc: lpAddress dwSize: dwSize flAllocationType: flAllocationType flProtect: flProtect [
	<cdecl: pointer VirtualAlloc (pointer, uint64, uint32, uint32)>
]

{ #category : #memory }
KernelDLL >> VirtualFree: lpAddress dwSize: dwSize dwFreeType: dwFreeType [
	<cdecl: sint32 VirtualFree (pointer, uint64, uint32)>
]
