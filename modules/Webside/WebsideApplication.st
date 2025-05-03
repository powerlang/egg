"
	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #WebsideApplication,
	#superclass : #Object,
	#instVars : [
		'name',
		'baseUri',
		'router',
		'api'
	],
	#category : #Webside
}

{#category : #accessing}
WebsideApplication class >> apis [
	^{WebsideAPI}
]

{#category : #configuration}
WebsideApplication class >> appName [
	^'Webside'
]

{#category : #configuration}
WebsideApplication class >> defaultBaseUri [
	^'/egg'
]

{#category : #configuration}
WebsideApplication class >> defaultFrontendUrl [
	^'http://localhost:3000'
]

{#category : #configuration}
WebsideApplication class >> defaultPort [
	^9000
]

{#category : #configuration}
WebsideApplication class >> frontendUrl [
	^self defaultFrontendUrl
]

{#category : #configuration}
WebsideApplication class >> on: anHttpServer [
	^self new configure: anHttpServer
]

{#category : #initialization}
WebsideApplication >> configure: anHttpServer [
	router := anHttpServer.
	baseUri := '/egg'.
	WebsideAPI addRoutesTo: self
]

{#category : #initialization}
WebsideApplication >> handleGET: request into: response with: anEvaluable [
	| api result string |
	api := WebsideAPI new
		       request: request;
			   response: response.
	result := anEvaluable evaluateWith: api.
	string := result isString ifTrue: [result] ifFalse: [result printString].
	response
		setContents: string type: 'text/html';
		headersAt: 'Access-Control-Allow-Origin' put: '*'.

]

{#category : #initialization}
WebsideApplication >> routeDELETE: uri to: anEvaluable [
	"router routeDELETE: uri to: anEvaluable with: self"
]

{#category : #initialization}
WebsideApplication >> routeGET: uri to: anEvaluable [
	router routeGET: baseUri, uri to: [:req :res | self handleGET: req into: res with: anEvaluable ]
]

{#category : #initialization}
WebsideApplication >> routePOST: uri to: anEvaluable [
	"router routePOST: uri to: anEvaluable with: self"
]
