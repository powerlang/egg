'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HTTPRequest category: #CPPHTTPServer!
ExternalObject subclass: #HTTPRequest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CPPHTTPServer'!
!HTTPRequest commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!HTTPRequest methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
paramAt: aString
	| addr |
	addr := self class module library 
		request: handle asParameter
		paramAt: aString externalCopy asParameter.

	addr = 0 ifTrue: [^nil].
	
	"should do better and look at encoding"
	^String fromMemory: addr pointedMemory
! !

!HTTPRequest methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
headersAt: aString
	| addr |
	addr := self class module library
		request: handle asParameter
		headersAt: aString externalCopy asParameter.

	addr = 0 ifTrue: [^nil].
	
	"should do better and look at encoding"
	^String fromMemory: addr pointedMemory
! !

!HTTPRequest methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
path
	| addr |
	addr := self class module library
		requestPath: handle asParameter.

	^String fromMemory: addr pointedMemory
! !

!HTTPRequest methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
queryAt: aString
	| addr |
	addr := self class module library 
		request: handle asParameter
		queryAt: aString externalCopy asParameter.

	addr = 0 ifTrue: [^nil].
	
	"should do better and look at encoding"
	^String fromMemory: addr pointedMemory
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HTTPRequest class' category: #CPPHTTPServer!
HTTPRequest class
	instanceVariableNames: ''!


