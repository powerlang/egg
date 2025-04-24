"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #CPPHTTPServer,
	#superclass : #ExternalObject,
	#instVars : [
		'library'
	],
	#category : #'CPPHTTPServer'
}

{ #category : #accessing }
CPPHTTPServer >> baseUri [
	^baseUri
]

{ #category : #accessing }
CPPHTTPServer >> baseUri: aString [
	baseUri := aString
]

{ #category : #spec }
CPPHTTPServer >> handle: request with: handler into: response with: selector [
	handler handle: request into: response with: selector.
	^ response
]

{ #category : #spec }
CPPHTTPServer >> initialize [
	library := CPPHTTPServerLibrary new open.
	self handle: library newServer.
]

{ #category : #spec }
CPPHTTPServer >> library [
	^library
]

{ #category : #spec }
CPPHTTPServer >> routeGET: uri to: selector with: handler [
	library
		server: self asParameter
		GET: uri externalCopy asParameter
		callback: [ :request :response | self handle: request with: handler into: response with: selector ] asCallback
]

{ #category : #spec }
CPPHTTPServer >> start [
	library startServer: self asParameter
]

{ #category : #initializing }
CPPHTTPServer >> stop [
	library stopServer: self asParameter
]
