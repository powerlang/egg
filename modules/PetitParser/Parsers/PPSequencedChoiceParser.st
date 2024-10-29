"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPSequencedChoiceParser,
	#superclass : #PPListParser,
	#category : #Parsers
}

{ #category : #operations }
PPSequencedChoiceParser >> & aRule [
	^self copyWith: aRule
]

{ #category : #parsing }
PPSequencedChoiceParser >> parseOn: aStream [
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
]

{ #category : #printing }
PPSequencedChoiceParser >> printTextOn: rtf [
	parsers
		do: [:p | p printSmalltalkReceiverOn: rtf]
		separatedBy: [rtf nextPutAll: ' & ']
]

