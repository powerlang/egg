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
		#'HTTP.CPPHTTPServer' -> #(CPPHTTPServer).
		#FFI -> #(ExternalLibrary).

	}
]

{ #category : #services }
HTTPServerModule >> main: arguments [
	| server |
	"Transcript show: 'starting server!'."
	ExternalLibrary module initializeForCurrentPlatform.

	server := CPPHTTPServer new apiClass: ExampleAPI.
	server
		baseUri: '/egg';
		routeGET: '/hello' to: #hello.
	server start.
	^0
]
