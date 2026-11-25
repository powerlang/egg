'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPActionParser category: #Parsers!
PPDelegateParser subclass: #PPActionParser
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPActionParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPActionParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
block
	"Answer the action block of the receiver."

	^ block
! !

!PPActionParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| element |
	^ (element := parser parseOn: aStream) isPetitFailure
		ifFalse: [ block value: element ]
		ifTrue: [ element ]
! !

!PPActionParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parser printSmalltalkReceiverOn: rtf.
	rtf cr; cr; nextPutAll: '==> '.
	block printSmalltalkReceiverOn: rtf
! !

!PPActionParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setBlock: aBlock
	block := aBlock
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPActionParser class' category: #Parsers!
PPActionParser class
	instanceVariableNames: ''!

!PPActionParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aParser block: aBlock
	^ (self on: aParser) setBlock: aBlock
! !


