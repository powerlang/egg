"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #CPPHTTPServerLibrary,
	#superclass : #ExternalLibrary,
	#category : #'CPPHTTPServer'
}

{ #category : #accessing }
CPPHTTPServerLibrary class >> libname [
	^'httpserver'
]

{ #category : #accessing }
CPPHTTPServerLibrary class >> libpath [
	^'./'
]

{ #category : #spec }
CPPHTTPServerLibrary >> deleteServer: aServer [
	<cdecl: void Server_Delete(pointer)>
]

{ #category : #spec }
CPPHTTPServerLibrary >> newServer [
	<cdecl: pointer Server_New()>
]

{ #category : #spec }
CPPHTTPServerLibrary >> server: aServer GET: url callback: aCallback [
	<cdecl: void Server_Get(pointer, pointer, pointer)>
]

{ #category : #spec }
CPPHTTPServerLibrary >> startServer: aServer [
	<cdecl: void Server_Start(pointer)>
]

{ #category : #initializing }
CPPHTTPServerLibrary >> stopServer: aServer [
	<cdecl: void Server_Stop(pointer)>
]

{ #category : #initializing }
CPPHTTPServerLibrary >> response: aResponse setContents: aString type: anotherString [
	<cdecl: void Response_SetContent(pointer, pointer, pointer)>
]
