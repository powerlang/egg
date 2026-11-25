'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPNotParser category: #Parsers!
PPDelegateParser subclass: #PPNotParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPNotParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPNotParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^element isPetitFailure ifFalse: [PPFailure message: '' from: aStream]
! !

!PPNotParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' not'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPNotParser class' category: #Parsers!
PPNotParser class
	instanceVariableNames: ''!


