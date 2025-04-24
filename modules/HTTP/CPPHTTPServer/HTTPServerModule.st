"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #HTTPServerModule,
	#superclass : #Module,
	#instVars : [
		'server'
	],
	#category : #'CPPHTTPServer'
}

{ #category : #spec }
HTTPServerModule >> imports [
	^{
		#FFI -> #(ExternalLibrary ExternalObject).
	}
]
