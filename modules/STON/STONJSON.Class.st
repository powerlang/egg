'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STONJSON category: #STON!
Object subclass: #STONJSON
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'STON'!
!STONJSON commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STONJSON class' category: #STON!
STONJSON class
	instanceVariableNames: ''!

!STONJSON class methodsFor:  'convenience' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromStream: stream
	^ STON fromStream: stream
! !

!STONJSON class methodsFor:  'convenience' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromString: string
	^ STON fromString: string
! !

!STONJSON class methodsFor:  'convenience' stamp: 'KenD 28/Jun/2026 13:27:39'!
put: object onStream: stream
	STON put: object asJsonOnStream: stream
! !

!STONJSON class methodsFor:  'convenience' stamp: 'KenD 28/Jun/2026 13:27:39'!
put: object onStreamPretty: stream
	STON put: object asJsonOnStreamPretty: stream
! !

!STONJSON class methodsFor:  'convenience' stamp: 'KenD 28/Jun/2026 13:27:39'!
toString: object
	^ STON toJsonString: object
! !

!STONJSON class methodsFor:  'convenience' stamp: 'KenD 28/Jun/2026 13:27:39'!
toStringPretty: object
	^ STON toJsonStringPretty: object
! !


