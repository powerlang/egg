"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #NativeCode,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'machineCode',
		'compiledCode'
	],
	#category : #Kernel
}

{ #category : #inspecting }
NativeCode class >> aspects [
	^#(#disassembledText32 #disassembledText64)
]

{ #category : #accessing }
NativeCode >> block [
	^compiledCode
]

{ #category : #accessing }
NativeCode >> block: aCompiledBlock [
	compiledCode := aCompiledBlock
]

{ #category : #accessing }
NativeCode >> bytes [
	^machineCode
]

{ #category : #accessing }
NativeCode >> code [
	^machineCode
]

{ #category : #accessing }
NativeCode >> code: bytes [
	machineCode := bytes
]

{ #category : #accessing }
NativeCode >> compiledCode [
	^compiledCode
]

{ #category : #accessing }
NativeCode >> compiledCode: anObject [
	compiledCode := anObject
]

{ #category : #accessing }
NativeCode >> disassembledText32 [
	^machineCode disassembledText32
]

{ #category : #accessing }
NativeCode >> disassembledText64 [
	^machineCode disassembledText64
]

{ #category : #accessing }
NativeCode >> entryPoint [
	^machineCode oop
]

{ #category : #testing }
NativeCode >> isNativeCode [
	^true
]

{ #category : #accessing }
NativeCode >> method [
	^compiledCode
]

{ #category : #accessing }
NativeCode >> method: aCompiledMethod [
	compiledCode := aCompiledMethod
]

{ #category : #accessing }
NativeCode >> nativeCodeAddress [
	^machineCode _oop
]

{ #category : #services }
NativeCode >> newEnvironment: anInteger [
	^Array new: anInteger
]

{ #category : #private }
NativeCode >> sendSites [
	^self select: [:obj | obj class == SendSite]
]

