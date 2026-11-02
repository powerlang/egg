"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRActiveProcess,
	#superclass : #ActiveProcess,
	#category : #Kernel
}

{ #category : #accessing }
LMRActiveProcess >> bp [
	^(self _framePointer _basicAt: 1) _asPointer
]
