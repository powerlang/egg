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


{ #category : #types }
FFIDescriptor class >> typeNames [
	^#(uint8 sint8 uint16 sint16 uint32 sint32 uint64 sint64 float double uchar schar ushort sshort uint sint ulong slong longdouble pointer complexFloat complexDouble complexLongdouble void)
]

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
FFIDescriptor >> argumentTypeNames [
	^self argumentTypes collect: [:type | self class typeNames at: type + 1]
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
FFIDescriptor >> returnType [
	^self at: self size - 1
]

{ #category : #accessing }
FFIDescriptor >> returnTypeName [
	^self class typeNames at: self returnType + 1
]

{ #category : #accessing }
FFIDescriptor >> returnType: anInteger [
	self at: self size - 1 put: anInteger
]
