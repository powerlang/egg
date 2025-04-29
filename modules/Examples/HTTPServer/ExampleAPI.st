Class {
	#name : #ExampleAPI,
	#superclass : #Object,
	#instVars : [
		'request',
		'response'
	],
	#category : #'Examples-HTTPServer'
}

{ #category : #spec }
ExampleAPI >> hello [
	| name |
	name := request paramAt: 'name'.
	name isEmpty ifTrue: [name := 'world'].
	response setContents: 'hello, ', name, '!' type: 'text/html'
]

{ #category : #spec }
ExampleAPI >> request: aRequest [
	request := aRequest
]

{ #category : #spec }
ExampleAPI >> response: aResponse [
	response := aResponse
]

