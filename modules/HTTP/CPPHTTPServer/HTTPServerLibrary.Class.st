'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HTTPServerLibrary category: #CPPHTTPServer!
ExternalLibrary subclass: #HTTPServerLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CPPHTTPServer'!
!HTTPServerLibrary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!HTTPServerLibrary methodsFor:  'server' stamp: 'KenD 28/Jun/2026 13:27:38'!
deleteServer: aServer
	<cdecl: void Server_Delete(pointer)>
! !

!HTTPServerLibrary methodsFor:  'server' stamp: 'KenD 28/Jun/2026 13:27:38'!
newServer
	<cdecl: pointer Server_New()>
! !

!HTTPServerLibrary methodsFor:  'server' stamp: 'KenD 28/Jun/2026 13:27:38'!
server: aServer DELETE: url callback: aCallback
	<cdecl: void Server_Delete(pointer, pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'server' stamp: 'KenD 28/Jun/2026 13:27:38'!
server: aServer GET: url callback: aCallback
	<cdecl: void Server_Get(pointer, pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'server' stamp: 'KenD 28/Jun/2026 13:27:38'!
server: aServer POST: url callback: aCallback
	<cdecl: void Server_Post(pointer, pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'server' stamp: 'KenD 28/Jun/2026 13:27:38'!
startServer: aServer
	<cdecl: void Server_Start(pointer)>
! !

!HTTPServerLibrary methodsFor:  'server' stamp: 'KenD 28/Jun/2026 13:27:38'!
stopServer: aServer
	<cdecl: void Server_Stop(pointer)>
! !

!HTTPServerLibrary methodsFor:  'request' stamp: 'KenD 28/Jun/2026 13:27:38'!
request: aRequest headersAt: aString
	<cdecl: pointer Request_HeadersAt(pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'request' stamp: 'KenD 28/Jun/2026 13:27:38'!
request: aRequest paramAt: aString
	<cdecl: pointer Request_ParamAt(pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'request' stamp: 'KenD 28/Jun/2026 13:27:38'!
request: aRequest queryAt: aString
	<cdecl: pointer Request_QueryAt(pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'request' stamp: 'KenD 28/Jun/2026 13:27:38'!
requestPath: aRequest
	<cdecl: pointer Request_Path(pointer)>
! !

!HTTPServerLibrary methodsFor:  'response' stamp: 'KenD 28/Jun/2026 13:27:38'!
response: aResponse headersAt: aString put: anotherString
	<cdecl: void Response_HeadersAtPut(pointer, pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'response' stamp: 'KenD 28/Jun/2026 13:27:38'!
response: aResponse setContents: aString type: anotherString
	<cdecl: void Response_SetContent(pointer, pointer, pointer)>
! !

!HTTPServerLibrary methodsFor:  'response' stamp: 'KenD 28/Jun/2026 13:27:38'!
response: aResponse status: anInteger
	<cdecl: void Response_SetStatus(pointer, pointer)>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HTTPServerLibrary class' category: #CPPHTTPServer!
HTTPServerLibrary class
	instanceVariableNames: ''!

!HTTPServerLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
libname
	^'httpserver'
! !

!HTTPServerLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
libpath
	^'./'
! !


