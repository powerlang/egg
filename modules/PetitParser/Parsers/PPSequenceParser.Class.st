'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPSequenceParser category: #Parsers!
PPListParser subclass: #PPSequenceParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPSequenceParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPSequenceParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
, aRule
	^ self copyWith: aRule
! !

!PPSequenceParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
map: aBlock
	^ self ==> [ :nodes | aBlock valueWithArguments: nodes ]
! !

!PPSequenceParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	"This is optimized code that avoids unnecessary block activations, do not change."

	| start elements element |
	start := aStream position.
	elements := Array new: parsers size.
	1 to: parsers size do: [ :index |
		element := (parsers at: index)
			parseOn: aStream.
		element isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements at: index put: element ].
	^ elements
! !

!PPSequenceParser methodsFor:  'permutation' stamp: 'KenD 28/Jun/2026 13:27:39'!
permutation: anArrayOfIntegers
	"Answer a permutation of the receivers sequence."
	
	anArrayOfIntegers do: [ :index |
		(index isInteger and: [ index between: 1 and: parsers size ])
			ifFalse: [ self error: 'Invalid permutation index: ' , index printString ] ].
	^ self ==> [ :nodes | anArrayOfIntegers collect: [ :index | nodes at: index ] ]
! !

!PPSequenceParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parsers
		do: [:p | p printSmalltalkReceiverOn: rtf]
		separatedBy: [rtf nextPutAll: ' , ']
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPSequenceParser class' category: #Parsers!
PPSequenceParser class
	instanceVariableNames: ''!


