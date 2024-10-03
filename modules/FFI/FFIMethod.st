"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FFIMethod,
	#superclass : #CompiledMethod,
	#type : #variable,
	#instVars : [
		'ffiName',
		'descriptor'
	],
	#category : #FFI
}


{ #category : #accessing }
FFIMethod >> descriptor [
	^descriptor
]

{ #category : #accessing }
FFIMethod >> descriptor: anFFIDescriptor [
	descriptor := anFFIDescriptor
]

{ #category : #accessing }
FFIMethod >> ffiName [
	^ffiName
]

{ #category : #accessing }
FFIMethod >> ffiName: aString [
	ffiName := aString
]
