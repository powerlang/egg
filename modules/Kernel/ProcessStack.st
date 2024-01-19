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
	^self new process: aProcess
]

{ #category : #private }
ProcessStack >> initialize [
	self vmSpecificInitialize
]

ProcessStack >> process [
	^process
]

ProcessStack >> process: aProcess [
	process := aProcess
]

ProcessStack >> release [
	self invalidate; unregister
]
