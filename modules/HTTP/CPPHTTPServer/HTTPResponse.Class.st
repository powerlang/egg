'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HTTPResponse category: #CPPHTTPServer!
ExternalObject subclass: #HTTPResponse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CPPHTTPServer'!
!HTTPResponse commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!HTTPResponse methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
notFound
	self
		status: 404;
		setContents: 'The server has not found anything matching the requested URI (Uniform Resource Identifier).' type: 'text/plain'.
! !

!HTTPResponse methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
setContents: aString type: anotherString
	self class module library
		response: handle asParameter
		setContents: aString externalCopy asParameter
		type: anotherString externalCopy asParameter
! !

!HTTPResponse methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
status: anInteger
	self class module library
		response: handle asParameter
		status: anInteger asParameter
! !

!HTTPResponse methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
headersAt: aString put: anotherString
	self class module library
		response: handle asParameter
		headersAt: aString externalCopy asParameter
		put: anotherString externalCopy asParameter
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HTTPResponse class' category: #CPPHTTPServer!
HTTPResponse class
	instanceVariableNames: ''!


