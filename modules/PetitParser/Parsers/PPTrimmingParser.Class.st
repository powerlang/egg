'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPTrimmingParser category: #Parsers!
PPDelegateParser subclass: #PPTrimmingParser
	instanceVariableNames: 'trimmer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPTrimmingParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPTrimmingParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| position element |
	position := aStream position.
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: position.
		^ element ].
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	^ element
! !

!PPTrimmingParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' trim'
! !

!PPTrimmingParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setTrimmer: aParser
	trimmer := aParser
! !

!PPTrimmingParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
trim
	"There is no point in trimming more than once."

	^ self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPTrimmingParser class' category: #Parsers!
PPTrimmingParser class
	instanceVariableNames: ''!

!PPTrimmingParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aParser trimmer: aTrimParser
	^ self new
		setParser: aParser;
		setTrimmer: aTrimParser;
		yourself
! !


