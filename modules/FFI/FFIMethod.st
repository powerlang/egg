"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FFIMethod,
	#superclass : #CompiledMethod,
	#type : #variable,
	#instVars : [
		'descriptor',
		'symbol',
		'address'
	],
	#category : #FFI
}

{ #category : #accessing }
FFIMethod >> address [
	^address
]

{ #category : #accessing }
FFIMethod >> address: anInteger [
	address := anInteger
]

{ #category : #accessing }
FFIMethod >> descriptor [
	^descriptor
]

{ #category : #accessing }
FFIMethod >> descriptor: anFFIDescriptor [
	descriptor := anFFIDescriptor
]

{ #category : #accessing }
FFIMethod >> descriptorBytes: aByteArray [
	descriptor := FFIDescriptor withAll: aByteArray
]

{ #category : #accessing }
FFIMethod >> symbol [
	^symbol
]

{ #category : #accessing }
FFIMethod >> symbol: aString [
	symbol := aString
]
