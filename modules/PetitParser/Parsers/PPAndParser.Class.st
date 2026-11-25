'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPAndParser category: #Parsers!
PPDelegateParser subclass: #PPAndParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPAndParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPAndParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
and
	^ self
! !

!PPAndParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^ element
! !

!PPAndParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' and'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPAndParser class' category: #Parsers!
PPAndParser class
	instanceVariableNames: ''!


