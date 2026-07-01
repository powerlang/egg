'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HTTPServer category: #CPPHTTPServer!
ExternalObject subclass: #HTTPServer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CPPHTTPServer'!
!HTTPServer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!HTTPServer methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
handle: requestHandle with: handler into: responseHandle
	| request response |
	request := HTTPRequest new handle: requestHandle.
	response := HTTPResponse new handle: responseHandle.
	handler evaluateWith: request with: response.
	^responseHandle
! !

!HTTPServer methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	self handle: self library newServer.
! !

!HTTPServer methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
library
	^self class module library
! !

!HTTPServer methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
routeGET: uri to: handler
	self library
		server: self asParameter
		GET: uri externalCopy asParameter
		callback: [ :request :response | self handle: request with: handler into: response ] asCallback
! !

!HTTPServer methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
start
	self library startServer: self asParameter
! !

!HTTPServer methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:38'!
stop
	self library stopServer: self asParameter
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HTTPServer class' category: #CPPHTTPServer!
HTTPServer class
	instanceVariableNames: ''!


HTTPServer initialize!

