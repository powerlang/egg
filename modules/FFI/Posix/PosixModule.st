"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #PosixModule,
	#superclass : #Module,
	#category : #FFI
}

{ #category : #services }
PosixModule >> externalCopyOfString: aString [
	^Kernel utf8 externalCopyOf: aString
]

{ #category : #services }
PosixModule >> imports [
	^{
		#Kernel -> #(Error).
		#FFI -> #(ExternalLibrary ExternalMemory LibC LibraryLoader)
	}
]

{ #category : #initialization }
PosixModule >> justLoaded [
	| constants |
	super justLoaded.
	constants := self class addNamespaceAs: #MemoryConstants.
	constants
		at: #PROT_NONE put: 0;
		at: #PROT_READ put: 1;
		at: #PROT_WRITE put: 2;
		at: #PROT_EXEC put: 4;
		at: #MAP_PRIVATE put: 2;
		at: #MAP_FIXED put: 16r10
]

{ #category : #memory }
PosixModule >> anonymousMapping [
	^self runsOnMac ifTrue: [16r1000] ifFalse: [16r20]
]

{ #category : #memory }
PosixModule >> commit: size at: address [
	^self map: size at: address protection: PROT_READ + PROT_WRITE flags: MAP_PRIVATE + MAP_FIXED
]

{ #category : #memory }
PosixModule >> map: size at: address protection: protection flags: flags [
	| mapping result |
	mapping := flags bitOr: self anonymousMapping.
	result := ExternalLibrary module libc
		mmap: address
		size: size
		protection: protection
		flags: mapping
		fd: -1
		offset: 0.
	^result = -1 ifTrue: [0] ifFalse: [result]
]

{ #category : #memory }
PosixModule >> release: address size: size [
	| result |
	result := ExternalLibrary module libc munmap: address size: size.
	^result = 0
]

{ #category : #memory }
PosixModule >> reserve: size [
	^self map: size at: 0 protection: PROT_NONE flags: MAP_PRIVATE
]

{ #category : #memory }
PosixModule >> makeExecutable: address size: size [
	| libc result |
	libc := ExternalLibrary module libc.
	self runsOnMac ifTrue: [libc sysIcacheInvalidate: address size: size].
	result := libc mprotect: address size: size protection: PROT_READ + PROT_EXEC.
	^result = 0
]

{ #category : #testing }
PosixModule >> runsOnMac [
	^Kernel host platformName endsWith: 'darwin'
]
