'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STON category: #STON!
Object subclass: #STON
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'STON'!
!STON commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STON class' category: #STON!
STON class
	instanceVariableNames: ''!

!STON class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
associationClass
	^ Association
! !

!STON class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
classNameKey
	^ #className
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromStream: readStream
	^ (self reader on: readStream) next
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromString: string
	^ self fromStream: string readStream
! !

!STON class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
jsonWriter
	^STONWriter new jsonMode: true
! !

!STON class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
listClass
	^Array
! !

!STON class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
mapClass
	^Dictionary
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
put: object asJsonOnStream: stream
	self jsonWriter on: stream; nextPut: object
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
put: object asJsonOnStreamPretty: stream
	self jsonWriter on: stream; nextPut: object
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
put: object onStream: stream
	(self writer on: stream) nextPut: object
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
put: object onStreamPretty: stream
	self writer on: stream; nextPut: object
! !

!STON class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
reader
	^ STONReader new
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
toJsonString: object
	^String streamContents: [:stream | self put: object asJsonOnStream: stream]
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
toJsonStringPretty: object
	^ String streamContents: [ :stream |
		self put: object asJsonOnStreamPretty: stream ]
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
toString: object
	^ String streamContents: [ :stream |
		self put: object onStream: stream ]
! !

!STON class methodsFor:  'convencience' stamp: 'KenD 28/Jun/2026 13:27:39'!
toStringPretty: object
	^ String streamContents: [ :stream |
		self put: object onStreamPretty: stream ]
! !

!STON class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
writer
	^ STONWriter new
! !


