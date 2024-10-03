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
	<cdecl: pointer LoadLibrary (pointer)>
]

{ #category : #accessing }
KernelDLL >> GetProcAddress: hModule lpProcName: lpProcName [
	<cdecl: pointer GetProcAddress (pointer, pointer)>
]
