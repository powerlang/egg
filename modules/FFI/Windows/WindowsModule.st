"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #WindowsModule,
	#superclass : #Module,
	#category : #FFI
}

{ #category : #services }
WindowsModule >> externalCopyOfString: aString [
	^Kernel utf16 externalCopyOf: aString
]


{ #category : #services }
WindowsModule >> imports [
	^{
		#Kernel -> #(ByteArray).
		#FFI -> #(ExternalLibrary LibC LibraryLoader)
	}
]

{ #category : #initialization }
WindowsModule >> justLoaded [
	| constants |
	super justLoaded.
	constants := self class addNamespaceAs: #MemoryConstants.
	constants
		at: #MEM_COMMIT put: 16r1000;
		at: #MEM_RESERVE put: 16r2000;
		at: #MEM_RELEASE put: 16r8000;
		at: #PAGE_NOACCESS put: 16r1;
		at: #PAGE_READWRITE put: 16r4;
		at: #PAGE_EXECUTE_READ put: 16r20
]

{ #category : #memory }
WindowsModule >> commit: size at: address [
	^self kernel32 VirtualAlloc: address dwSize: size flAllocationType: MEM_COMMIT flProtect: PAGE_READWRITE
]

{ #category : #memory }
WindowsModule >> kernel32 [
	^ExternalLibrary module loader kernel32
]

{ #category : #memory }
WindowsModule >> release: address size: size [
	| freed |
	freed := self kernel32 VirtualFree: address dwSize: 0 dwFreeType: MEM_RELEASE.
	^freed != 0
]

{ #category : #memory }
WindowsModule >> reserve: size [
	^self kernel32 VirtualAlloc: 0 dwSize: size flAllocationType: MEM_RESERVE flProtect: PAGE_NOACCESS
]

{ #category : #memory }
WindowsModule >> makeExecutable: address size: size [
	| previous protected |
	previous := ByteArray new: 4.
	protected := self kernel32 VirtualProtect: address dwSize: size flNewProtect: PAGE_EXECUTE_READ lpflOldProtect: previous.
	self kernel32 FlushInstructionCache: -1 lpBaseAddress: address dwSize: size.
	^protected != 0
]
