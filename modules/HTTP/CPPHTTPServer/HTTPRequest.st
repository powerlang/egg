"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #HTTPRequest,
	#superclass : #ExternalObject,
	#category : #'CPPHTTPServer'
}

{ #category : #spec }
HTTPRequest >> paramAt: aString [
	| addr |
	addr := self class module library 
		request: handle asParameter
		paramAt: aString externalCopy asParameter.

	addr = 0 ifTrue: [^nil].
	
	"should do better and look at encoding"
	^String fromMemory: addr pointedMemory
]
