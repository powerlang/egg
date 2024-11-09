Class {
	#name : #ExampleAPI,
	#superclass : #Object,
	#instVars : [
		'request',
		'response',
		'server'
	],
	#category : #'Examples-HTTPServer'
}

{ #category : #spec }
ExampleAPI >> hello [
	server library 
		response: response asParameter
		setContents: 'hello, world!' externalCopy asParameter
		type: 'text/html' externalCopy asParameter
]

{ #category : #spec }
ExampleAPI >> request: aRequest [
	request := aRequest
]

{ #category : #spec }
ExampleAPI >> response: aResponse [
	response := aResponse
]

{ #category : #spec }
ExampleAPI >> server: aCPPHTTPServer [
	server := aCPPHTTPServer
]

