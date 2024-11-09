"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #CPPHTTPServerModule,
	#superclass : #Module,
	#instVars : [
		'server'
	],
	#category : #'CPPHTTPServer'
}

{ #category : #spec }
CPPHTTPServerModule >> imports [
	^{
		#FFI -> #(ExternalLibrary ExternalObject).
	}
]
