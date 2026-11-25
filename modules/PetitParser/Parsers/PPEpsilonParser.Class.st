'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPEpsilonParser category: #Parsers!
PPParser subclass: #PPEpsilonParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPEpsilonParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPEpsilonParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	^ nil
! !

!PPEpsilonParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	rtf
		useColor: PaintingVisitor new specialColor
		while: [rtf nextPutAll: 'nil'].
	rtf nextPutAll: ' asParser'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPEpsilonParser class' category: #Parsers!
PPEpsilonParser class
	instanceVariableNames: ''!


