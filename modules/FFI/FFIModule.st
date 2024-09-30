"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FFIModule,
	#superclass : #Module,
	#instVars : [
		'loader'
	],
	#category : #Kernel
}

{ #category : #private }
FFIModule >> imports [
	^{
		#Kernel -> #(ArrayedCollection Behavior ByteArray ByteArraySegment CharacterArray Float Integer IdentitySet String WordSize)
	}
]

{ #category : #private }
FFIModule >> initializeFor: moduleName loader: loaderName [
	| module |
	module := Kernel loadModule: #moduleName.
	self namespace at: #OS put: module.
	loader := module at: loaderName
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
FFIModule >> justLoaded [
	super justLoaded.
	ExternalMemory initializeConstants.
]

{ #category : #accessing }
FFIModule >> loader [
	^loader
]

