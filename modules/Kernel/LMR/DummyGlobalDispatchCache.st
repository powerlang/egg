"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #DummyGlobalDispatchCache,
	#superclass : #GlobalDispatchCache,
	#category : #Kernel
}

{ #category : #services }
DummyGlobalDispatchCache >> lookupAndCache: selector in: aProtocol [
	^self _lookup: selector in: aProtocol
]

