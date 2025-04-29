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
HTTPServerLibrary >> server: aServer GET: url callback: aCallback [
	<cdecl: void Server_Get(pointer, pointer, pointer)>
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
HTTPServerLibrary >> request: aRequest paramAt: aString [
	<cdecl: pointer Request_ParamAt(pointer, pointer)>
]

{ #category : #response }
HTTPServerLibrary >> response: aResponse setContents: aString type: anotherString [
	<cdecl: void Response_SetContent(pointer, pointer, pointer)>
]
