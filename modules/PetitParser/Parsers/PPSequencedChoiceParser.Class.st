'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPSequencedChoiceParser category: #Parsers!
PPListParser subclass: #PPSequencedChoiceParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPSequencedChoiceParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPSequencedChoiceParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
& aRule
	^self copyWith: aRule
! !

!PPSequencedChoiceParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	"
	This is optimized code that avoids unnecessary block activations, do not change.
	When all choices fail, the last failure is answered.
	"
	| element elements start |
	elements := Array new: parsers size.
	start := aStream position.
	1 to: parsers size do: [:index | 
		element := (parsers at: index) parseOn: aStream.
		element isPetitFailure ifFalse: [elements at: index put: element]].
	^(elements anySatisfy: [:elem | elem notNil]) ifTrue: [elements] ifFalse: [
		aStream position: start.
		PPFailure message: 'No match for any "and / or" rule' from: aStream]
! !

!PPSequencedChoiceParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parsers
		do: [:p | p printSmalltalkReceiverOn: rtf]
		separatedBy: [rtf nextPutAll: ' & ']
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPSequencedChoiceParser class' category: #Parsers!
PPSequencedChoiceParser class
	instanceVariableNames: ''!


