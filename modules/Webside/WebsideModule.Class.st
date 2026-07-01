'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #WebsideModule category: #Webside!
Module subclass: #WebsideModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Webside'!
!WebsideModule commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
!

!WebsideModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:32:24'!
imports
	^{
		#Development -> #(CodeSearch MethodSearch MethodSearchScope).
		#FFI -> #(ExternalLibrary).
		#'HTTP.CPPHTTPServer' -> #(HTTPServer).
		#Json -> #(JsonObject JsonWriter).
		#Kernel -> #(ByteArray Error IdentitySet OrderedDictionary ProtoObject ReadStream Species)
	}
! !

!WebsideModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:32:24'!
main: arguments
	| server webside |
	Kernel log: 'configuring server, initializing!!', String cr.

	ExternalLibrary module initializeForCurrentPlatform.
	Kernel log: 'server configured, starting!!', String cr.
	server := HTTPServer new.
	webside := WebsideApplication on: server.

	server start
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WebsideModule class' category: #Webside!
WebsideModule class
	instanceVariableNames: ''!


