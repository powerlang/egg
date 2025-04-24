"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #HTTPServer,
	#superclass : #ExternalObject,
	#instVars : [
		'library'
	],
	#category : #'HTTPServer'
}

{ #category : #accessing }
HTTPServer >> baseUri [
	^baseUri
]

{ #category : #accessing }
HTTPServer >> baseUri: aString [
	baseUri := aString
]

{ #category : #spec }
HTTPServer >> handle: request with: handler into: response with: selector [
	handler handle: request into: response with: selector.
	^ response
]

{ #category : #spec }
HTTPServer >> initialize [
	library := HTTPServerLibrary new open.
	self handle: library newServer.
]

{ #category : #spec }
HTTPServer >> library [
	^library
]

{ #category : #spec }
HTTPServer >> routeGET: uri to: selector with: handler [
	library
		server: self asParameter
		GET: uri externalCopy asParameter
		callback: [ :request :response | self handle: request with: handler into: response with: selector ] asCallback
]

{ #category : #spec }
HTTPServer >> start [
	library startServer: self asParameter
]

{ #category : #initializing }
HTTPServer >> stop [
	library stopServer: self asParameter
]
