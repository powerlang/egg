"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #HTTPServer,
	#superclass : #ExternalObject,
	#category : #'CPPHTTPServer'
}

{ #category : #spec }
HTTPServer >> handle: requestHandle with: handler into: responseHandle with: selector [
	| request response |
	request := HTTPRequest new handle: requestHandle.
	response := HTTPResponse new handle: responseHandle.
	handler handle: request into: response with: selector.
	^responseHandle
]

{ #category : #spec }
HTTPServer >> initialize [
	self handle: self library newServer.
]

{ #category : #spec }
HTTPServer >> library [
	^self class module library
]

{ #category : #spec }
HTTPServer >> routeGET: uri to: selector with: handler [
	self library
		server: self asParameter
		GET: uri externalCopy asParameter
		callback: [ :request :response | self handle: request with: handler into: response with: selector ] asCallback
]

{ #category : #spec }
HTTPServer >> start [
	self library startServer: self asParameter
]

{ #category : #initializing }
HTTPServer >> stop [
	self library stopServer: self asParameter
]
