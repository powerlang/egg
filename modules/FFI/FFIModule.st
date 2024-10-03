"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FFIModule,
	#superclass : #Module,
	#instVars : [
		'loader',
		'mallocHeap',
		'defaultHeap',
		'libc'
	],
	#category : #FFI
}

{ #category : #accessing }
FFIModule >> defaultHeap [
	^defaultHeap
]

{ #category : #private }
FFIModule >> imports [
	^{
		#Kernel -> #(ArrayedCollection Behavior ByteArray ByteArraySegment CharacterArray Float Integer IdentitySet String WordSize)
	}
]

{ #category : #private }
FFIModule >> initializeFor: moduleName loader: loaderName [
	| module loaderType |
	module := Kernel load: moduleName.
	self namespace
		at: #FFI put: self;
		at: #OS put: module.
	loaderType := module namespace at: loaderName.
	loader := loaderType new.
	libc := LibC new.
	loader bootstrapOpen: libc.
	defaultHeap := mallocHeap := MallocHeap new
]

{ #category : #initialization }
FFIModule >> initializeForCurrentPlatform [
	| platform |
	platform := Kernel host platformName.
	(platform endsWith: 'linux-gnu') ifTrue: [^self initializeForLinux].
	(platform endsWith: 'darwin') ifTrue: [^self initializeForMac].
	(platform endsWith: 'win32') ifTrue: [^self initializeForWindows].
	self error: platform, ' platform not yet supported by FFI module'
]

{ #category : #initialization }
FFIModule >> initializeForMac [
	self initializeFor: #'FFI.Mac' loader: #MacLibraryLoader
]

{ #category : #initialization }
FFIModule >> initializeForLinux [
	self initializeFor: #'FFI.Linux' loader: #LinuxLibraryLoader
]

{ #category : #initialization }
FFIModule >> initializeForWindows [
	self initializeFor: #'FFI.Windows' loader: #WindowsLibraryLoader
]

{ #category : #initialization }
FFIModule >> initialize [
	super initialize.
	ExternalMemory initializeConstants.
]

{ #category : #accessing }
FFIModule >> libc [
	^libc
]

{ #category : #accessing }
FFIModule >> loader [
	^loader
]

