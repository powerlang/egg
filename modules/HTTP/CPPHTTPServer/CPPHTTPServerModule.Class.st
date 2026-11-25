'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #CPPHTTPServerModule category: #CPPHTTPServer!
Module subclass: #CPPHTTPServerModule
	instanceVariableNames: 'library'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CPPHTTPServer'!
!CPPHTTPServerModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!CPPHTTPServerModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
imports
	^{
		#FFI -> #(ExternalLibrary ExternalObject).
	}
! !

!CPPHTTPServerModule methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
library
	^library ifNil: [library := HTTPServerLibrary new open]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CPPHTTPServerModule class' category: #CPPHTTPServer!
CPPHTTPServerModule class
	instanceVariableNames: ''!


