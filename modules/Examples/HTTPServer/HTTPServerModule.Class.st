'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #HTTPServerModule category: #'Examples-HTTPServer'!
Module subclass: #HTTPServerModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Examples-HTTPServer'!
!HTTPServerModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#FFI -> #(ExternalLibrary).
		#'HTTP.CPPHTTPServer' -> #(HTTPServer).
	}
! !

!HTTPServerModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
handle: request into: response with: selector
	| api |
	api := ExampleAPI new
		       request: request;
			   response: response.
	api perform: selector.
	"response headersAt: 'Access-Control-Allow-Origin' put: '*'."
! !

!HTTPServerModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
main: arguments
	| server base |
	ExternalLibrary module initializeForCurrentPlatform.
	base := arguments at: 3 ifAbsent: ['/egg'].
	server := HTTPServer new.
	server
		routeGET: base, '/hello/{name}' to: [:req :res | self handle: req into: res with: #hello].
	Kernel log: 'server configured, starting!!', String cr.
	server start.
	^0
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HTTPServerModule class' category: #'Examples-HTTPServer'!
HTTPServerModule class
	instanceVariableNames: ''!


