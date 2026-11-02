"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRCompiledMethod,
	#superclass : #CompiledMethod,
	#type : #variable,
	#category : #Kernel
}

{ #category : #services }
LMRCompiledMethod >> flushFromCaches [
	self beFlushed
]

{ #category : #services }
LMRCompiledMethod >> prepareForExecution [
	self isNativized ifFalse: [Kernel prepareForExecution: self]
]
