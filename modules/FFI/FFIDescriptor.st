"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #FFIDescriptor,
	#superclass : #ArrayedCollection,
	#type : #bytes,
	#category : #Kernel
}


{ #category : #accessing }
FFIDescriptor >> argumentCount [
	^self size - WordSize - 2
]

{ #category : #accessing }
FFIDescriptor >> argumentTypeAt: index [
	^self at: WordSize + 1 + index
]

{ #category : #accessing }
FFIDescriptor >> argumentTypeAt: index put: typeInteger [
	self at: WordSize + 1 + index put: typeInteger
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
	^self at: WordSize + 1
]

{ #category : #accessing }
FFIDescriptor >> callingConvention: ccCode [
	self at: WordSize + 1 put: ccCode
]

{ #category : #accessing }
FFIDescriptor >>returnType [
	^self at: self size
]

{ #category : #accessing }
FFIDescriptor >> returnType: anInteger [
	self at: WordSize + 2 + self argumentCount put: anInteger
]
