'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #TimestampAdaptor category: #JSON!
DataAdaptor subclass: #TimestampAdaptor
	instanceVariableNames: 'format'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!TimestampAdaptor commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!TimestampAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
dataFrom: anObject
	| ts |
	ts := anObject isDate
		ifTrue: [anObject utc]
		ifFalse: [anObject asTimestamp].
	^ts perform: format
! !

!TimestampAdaptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
format: aSymbol
	format := aSymbol
! !

!TimestampAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: aString
	^Timestamp perform: (format , ':') asSymbol with: aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TimestampAdaptor class' category: #JSON!
TimestampAdaptor class
	instanceVariableNames: ''!

!TimestampAdaptor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
iso8601
	^self new format: #iso8601! !


