"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #CPPHTTPServer,
	#superclass : #ExternalObject,
	#instVars : [
		'library',
		'apiClass',
		'baseUri'
	],
	#category : #'CPPHTTPServer'
}

{ #category : #accessing }
CPPHTTPServer >> apiClass: aClass [
	apiClass := aClass
]

{ #category : #accessing }
CPPHTTPServer >> baseUri [
	^baseUri
]

{ #category : #accessing }
CPPHTTPServer >> baseUri: aString [
	baseUri := aString
]

{ #category : #spec }
CPPHTTPServer >> handleRequest: request into: response with: selector [
	| api |
	api := apiClass new
		       server: self;
		       request: request;
			   response: response.
	api perform: selector.
	"response headersAt: 'Access-Control-Allow-Origin' put: '*'."
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
CPPHTTPServer >> routeGET: uri to: selector [
	library
		server: self asParameter
		GET: (baseUri , uri) externalCopy asParameter
		callback: [ :request :response | self handleRequest: request into: response with: selector ] asCallback
]

{ #category : #spec }
CPPHTTPServer >> start [
	library startServer: self asParameter
]

{ #category : #initializing }
CPPHTTPServer >> stop [
	library stopServer: self asParameter
]
