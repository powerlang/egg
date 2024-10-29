"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPSequenceParser,
	#superclass : #PPListParser,
	#category : #Parsers
}

{ #category : #operations }
PPSequenceParser >> , aRule [
	^ self copyWith: aRule
]

{ #category : #operations }
PPSequenceParser >> map: aBlock [
	^ self ==> [ :nodes | aBlock valueWithArguments: nodes ]
]

{ #category : #parsing }
PPSequenceParser >> parseOn: aStream [
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
]

{ #category : #permutation }
PPSequenceParser >> permutation: anArrayOfIntegers [
	"Answer a permutation of the receivers sequence."
	
	anArrayOfIntegers do: [ :index |
		(index isInteger and: [ index between: 1 and: parsers size ])
			ifFalse: [ self error: 'Invalid permutation index: ' , index printString ] ].
	^ self ==> [ :nodes | anArrayOfIntegers collect: [ :index | nodes at: index ] ]
]

{ #category : #printing }
PPSequenceParser >> printTextOn: rtf [
	parsers
		do: [:p | p printSmalltalkReceiverOn: rtf]
		separatedBy: [rtf nextPutAll: ' , ']
]

