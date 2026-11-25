'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #WebsideApplication category: #Webside!
Object subclass: #WebsideApplication
	instanceVariableNames: 'name baseUri router api'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Webside'!
!WebsideApplication commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
!

!WebsideApplication methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
configure: anHttpServer
	router := anHttpServer.
	baseUri := '/egg'.
	WebsideAPI addRoutesTo: self
! !

!WebsideApplication methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:32:24'!
expectsJson: anHttpRequest
	| accept |
	accept := anHttpRequest headersAt: 'Accept'.
	^accept notNil and: [accept includesString: 'application/json']
! !

!WebsideApplication methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleGET: request into: response with: anEvaluable
	| api result type contents |
	api := WebsideAPI new
		       request: request;
			   response: response.
	result := anEvaluable evaluateWith: api.
	result isAssociation
		ifTrue: [
			type := result value.
			result := result key]
		ifFalse: [
			(self expectsJson: request)
				ifTrue: [
					type := 'application/json'.
					result := JsonWriter write: result]
				ifFalse: [type := 'text/html']].

	contents := result isString ifTrue: [result] ifFalse: [result printString].
	result ifNotNil: [response setContents: contents type: type].
	response headersAt: 'Access-Control-Allow-Origin' put: '*'
! !

!WebsideApplication methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
routeDELETE: uri to: anEvaluable
	"router routeDELETE: uri to: anEvaluable with: self"
! !

!WebsideApplication methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
routeGET: uri to: anEvaluable
	router routeGET: baseUri, uri to: [:req :res | self handleGET: req into: res with: anEvaluable ]
! !

!WebsideApplication methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
routePOST: uri to: anEvaluable
	"router routePOST: uri to: anEvaluable with: self"
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WebsideApplication class' category: #Webside!
WebsideApplication class
	instanceVariableNames: ''!

!WebsideApplication class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
apis
	^{WebsideAPI}
! !

!WebsideApplication class methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:24'!
appName
	^'Webside'
! !

!WebsideApplication class methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultBaseUri
	^'/egg'
! !

!WebsideApplication class methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultFrontendUrl
	^'http://localhost:3000'
! !

!WebsideApplication class methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultPort
	^9000
! !

!WebsideApplication class methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:24'!
frontendUrl
	^self defaultFrontendUrl
! !

!WebsideApplication class methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:32:24'!
on: anHttpServer
	^self new configure: anHttpServer
! !


