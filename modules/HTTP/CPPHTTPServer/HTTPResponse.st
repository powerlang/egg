"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #HTTPResponse,
	#superclass : #ExternalObject,
	#category : #'CPPHTTPServer'
}

{ #category : #spec }
HTTPResponse >> notFound [
	self
		status: 404;
		setContents: 'The server has not found anything matching the requested URI (Uniform Resource Identifier).' type: 'text/plain'.
]

{ #category : #spec }
HTTPResponse >> setContents: aString type: anotherString [
	self class module library
		response: handle asParameter
		setContents: aString externalCopy asParameter
		type: anotherString externalCopy asParameter
]

{ #category : #spec }
HTTPResponse >> status: anInteger [
	self class module library
		response: handle asParameter
		status: anInteger asParameter
]

{ #category : #spec }
HTTPResponse >> headersAt: aString put: anotherString [
	self class module library
		response: handle asParameter
		headersAt: aString externalCopy asParameter
		put: anotherString externalCopy asParameter
]
