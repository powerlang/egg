'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPFlattenParser category: #Parsers!
PPDelegateParser subclass: #PPFlattenParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPFlattenParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPFlattenParser methodsFor:  'hooks' stamp: 'KenD 28/Jun/2026 13:27:39'!
create: aCollection start: aStartInteger stop: aStopInteger
	^ aCollection copyFrom: aStartInteger to: aStopInteger
! !

!PPFlattenParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| start element stop |
	start := aStream position.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: start.
		^ element ].
	stop := aStream position.
	^ self create: aStream collection start: start + 1 stop: stop
! !

!PPFlattenParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' flatten'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPFlattenParser class' category: #Parsers!
PPFlattenParser class
	instanceVariableNames: ''!


