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

{ #category : #spec }
HTTPServerLibrary >> deleteServer: aServer [
	<cdecl: void Server_Delete(pointer)>
]

{ #category : #spec }
HTTPServerLibrary >> newServer [
	<cdecl: pointer Server_New()>
]

{ #category : #spec }
HTTPServerLibrary >> server: aServer GET: url callback: aCallback [
	<cdecl: void Server_Get(pointer, pointer, pointer)>
]

{ #category : #spec }
HTTPServerLibrary >> startServer: aServer [
	<cdecl: void Server_Start(pointer)>
]

{ #category : #initializing }
HTTPServerLibrary >> stopServer: aServer [
	<cdecl: void Server_Stop(pointer)>
]

{ #category : #initializing }
HTTPServerLibrary >> response: aResponse setContents: aString type: anotherString [
	<cdecl: void Response_SetContent(pointer, pointer, pointer)>
]
