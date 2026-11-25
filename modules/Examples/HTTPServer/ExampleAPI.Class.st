'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ExampleAPI category: #'Examples-HTTPServer'!
Object subclass: #ExampleAPI
	instanceVariableNames: 'request response'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Examples-HTTPServer'!
!ExampleAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
hello
	| name |
	name := request paramAt: 'name'.
	name isEmpty ifTrue: [name := 'world'].
	response setContents: 'hello, ', name, '!!' type: 'text/html'
! !

!ExampleAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
request: aRequest
	request := aRequest
! !

!ExampleAPI methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
response: aResponse
	response := aResponse
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExampleAPI class' category: #'Examples-HTTPServer'!
ExampleAPI class
	instanceVariableNames: ''!


