"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessStack,
	#superclass : #Object,
	#instVars : [
		'process'
	],
	#category : #Kernel
}

{ #category : #private }
ProcessStack class >> on: aProcess [
	^self errorVMSpecific
]

{ #category : #private }
ProcessStack >> contextSwitchTo: next [
	self subclassResponsibility
]

ProcessStack >> process [
	^process
]

ProcessStack >> process: aProcess [
	process := aProcess
]
