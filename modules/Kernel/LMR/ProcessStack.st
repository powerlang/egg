"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRProcessStack,
	#superclass : #ProcessStack,
	#category : #Kernel
}

{ #category : #'instance creation' }
LMRProcessStack class >> on: aProcess [
	^ProcessLMRStack on: aProcess
]
