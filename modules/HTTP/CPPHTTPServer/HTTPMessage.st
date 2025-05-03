"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #HTTPMessage,
	#superclass : #HTTPObject,
	#category : #'CPPHTTPServer'
}

{ #category : #spec }
HTTPMessage >> accept [
	^self headersAt: 'Accept'
]

{ #category : #spec }
HTTPMessage >> headersAt: aString [
	^self subclassResponsibility
]