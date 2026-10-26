'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #HTTPMessage category: #CPPHTTPServer!
HTTPObject subclass: #HTTPMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CPPHTTPServer'!
!HTTPMessage commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!HTTPMessage methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
accept
	^self headersAt: 'Accept'
! !

!HTTPMessage methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
headersAt: aString
	^self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HTTPMessage class' category: #CPPHTTPServer!
HTTPMessage class
	instanceVariableNames: ''!


