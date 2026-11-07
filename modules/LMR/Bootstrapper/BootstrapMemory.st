"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #BootstrapMemory,
	#superclass : #Object,
	#category : #'LMR-Bootstrapper'
}

{ #category : #allocation }
BootstrapMemory >> newLargeArray: anInteger [
	^Array new: anInteger
]

{ #category : #allocation }
BootstrapMemory >> pinnedCopy: anObject [
	^anObject copy
]
