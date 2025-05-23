Class {
	#name : #HTTPServerModule,
	#superclass : #Module,
	#instVars : [
		''
	],
	#category : #'Examples-HTTPServer'
}

{ #category : #spec }
HTTPServerModule >> imports [
	^{
		#FFI -> #(ExternalLibrary).
		#'HTTP.CPPHTTPServer' -> #(HTTPServer).
	}
]

{ #category : #spec }
HTTPServerModule >> handle: request into: response with: selector [
	| api |
	api := ExampleAPI new
		       request: request;
			   response: response.
	api perform: selector.
	"response headersAt: 'Access-Control-Allow-Origin' put: '*'."
]

{ #category : #services }
HTTPServerModule >> main: arguments [
	| server base |
	ExternalLibrary module initializeForCurrentPlatform.
	base := arguments at: 3 ifAbsent: ['/egg'].
	server := HTTPServer new.
	server
		routeGET: base, '/hello/{name}' to: [:req :res | self handle: req into: res with: #hello].
	Kernel log: 'server configured, starting!', String cr.
	server start.
	^0
]
