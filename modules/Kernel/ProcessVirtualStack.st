"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessVirtualStack,
	#superclass : #ProcessStack,
	#instVars : [
		'topFrame'
	],
	#category : #Kernel
}

{ #category : #private }
ProcessVirtualStack >> initialize [
	self vmSpecificInitialize
]

ProcessVirtualStack >> frameIndex [
	self errorVMSpecific
]

ProcessVirtualStack >> vmSpecificInitialize [
	self errorVMSpecific
]
