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

{ #category : #spec }
HTTPRequest >> headersAt: aString [
	| addr |
	addr := self class module library
		request: handle asParameter
		headersAt: aString externalCopy asParameter.

	addr = 0 ifTrue: [^nil].
	
	"should do better and look at encoding"
	^String fromMemory: addr pointedMemory
]

{ #category : #spec }
HTTPRequest >> path [
	| addr |
	addr := self class module library
		requestPath: handle asParameter.

	^String fromMemory: addr pointedMemory
]

{ #category : #spec }
HTTPRequest >> queryAt: aString [
	| addr |
	addr := self class module library 
		request: handle asParameter
		queryAt: aString externalCopy asParameter.

	addr = 0 ifTrue: [^nil].
	
	"should do better and look at encoding"
	^String fromMemory: addr pointedMemory
]
