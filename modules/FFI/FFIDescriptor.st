"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FFIDescriptor,
	#superclass : #ArrayedCollection,
	#type : #bytes,
	#category : #FFI
}


{ #category : #accessing }
FFIDescriptor >> argumentCount [
	^self size - 2
]

{ #category : #accessing }
FFIDescriptor >> argumentTypeAt: index [
	^self at: index
]

{ #category : #accessing }
FFIDescriptor >> argumentTypeAt: index put: typeInteger [
	self at: index put: typeInteger
]

{ #category : #accessing }
FFIDescriptor >> argumentTypes [
	^(1 to: self argumentCount) collect: [:i | self argumentTypeAt: i]
]

{ #category : #accessing }
FFIDescriptor >> argumentTypes: types [
	types withIndexDo: [:code :i | self argumentTypeAt: i put: code]
]

{ #category : #accessing }
FFIDescriptor >> callingConvention [
	^self at: self size
]

{ #category : #accessing }
FFIDescriptor >> callingConvention: ccCode [
	self at: self size put: ccCode
]

{ #category : #accessing }
FFIDescriptor >>returnType [
	^self at: self size - 1
]

{ #category : #accessing }
FFIDescriptor >> returnType: anInteger [
	self at: self size - 1 put: anInteger
]
