"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #HTTPServerLibrary,
	#superclass : #ExternalLibrary,
	#category : #'CPPHTTPServer'
}

{ #category : #accessing }
HTTPServerLibrary class >> libname [
	^'httpserver'
]

{ #category : #accessing }
HTTPServerLibrary class >> libpath [
	^'./'
]

{ #category : #server }
HTTPServerLibrary >> deleteServer: aServer [
	<cdecl: void Server_Delete(pointer)>
]

{ #category : #server }
HTTPServerLibrary >> newServer [
	<cdecl: pointer Server_New()>
]

{ #category : #server }
HTTPServerLibrary >> server: aServer DELETE: url callback: aCallback [
	<cdecl: void Server_Delete(pointer, pointer, pointer)>
]

{ #category : #server }
HTTPServerLibrary >> server: aServer GET: url callback: aCallback [
	<cdecl: void Server_Get(pointer, pointer, pointer)>
]

{ #category : #server }
HTTPServerLibrary >> server: aServer POST: url callback: aCallback [
	<cdecl: void Server_Post(pointer, pointer, pointer)>
]


{ #category : #server }
HTTPServerLibrary >> startServer: aServer [
	<cdecl: void Server_Start(pointer)>
]

{ #category : #server }
HTTPServerLibrary >> stopServer: aServer [
	<cdecl: void Server_Stop(pointer)>
]

{ #category : #request }
HTTPServerLibrary >> request: aRequest headersAt: aString [
	<cdecl: pointer Request_HeadersAt(pointer, pointer)>
]

{ #category : #request }
HTTPServerLibrary >> request: aRequest paramAt: aString [
	<cdecl: pointer Request_ParamAt(pointer, pointer)>
]

{ #category : #request }
HTTPServerLibrary >> request: aRequest queryAt: aString [
	<cdecl: pointer Request_QueryAt(pointer, pointer)>
]

{ #category : #request }
HTTPServerLibrary >> requestPath: aRequest [
	<cdecl: pointer Request_Path(pointer)>
]

{ #category : #response }
HTTPServerLibrary >> response: aResponse headersAt: aString put: anotherString [
	<cdecl: void Response_HeadersAtPut(pointer, pointer, pointer)>
]

{ #category : #response }
HTTPServerLibrary >> response: aResponse setContents: aString type: anotherString [
	<cdecl: void Response_SetContent(pointer, pointer, pointer)>
]

{ #category : #response }
HTTPServerLibrary >> response: aResponse status: anInteger [
	<cdecl: void Response_SetStatus(pointer, pointer)>
]