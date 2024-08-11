"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRSymbol,
	#superclass : #Symbol,
	#category : #Kernel
}

{ #category : #private }
LMRSymbol >> flushCacheFor: species [
	GlobalDispatchCache current flush: self forSpecies: species.
	SendSite flush: self
]

