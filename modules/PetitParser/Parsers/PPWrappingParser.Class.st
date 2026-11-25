'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPWrappingParser category: #Parsers!
PPActionParser subclass: #PPWrappingParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPWrappingParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPWrappingParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	^ block value: aStream value: [ parser parseOn: aStream ]
! !

!PPWrappingParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parser printSmalltalkReceiverOn: rtf.
	rtf
		useColor: PaintingVisitor new defaultColor
		while: [rtf nextPutAll: ' >=> '].
	block printTextOn: rtf
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPWrappingParser class' category: #Parsers!
PPWrappingParser class
	instanceVariableNames: ''!


