"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPCharSetPredicate,
	#superclass : #Object,
	#instVars : [
		'block',
		'classification'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPCharSetPredicate class >> on: aBlock [
	^ self basicNew initializeOn: aBlock
]

{ #category : #initialization }
PPCharSetPredicate >> initializeOn: aBlock [
	block := aBlock.
	classification := Array new: 255.
	1 to: classification size do: [ :index |
		classification at: index put: (block
			value: (Character value: index)) ]
]

{ #category : #evaluating }
PPCharSetPredicate >> value: aCharacter [
	| index |
	index := aCharacter asInteger.
	index == 0
		ifTrue: [ ^ block value: aCharacter ].
	index > 255
		ifTrue: [ ^ block value: aCharacter ].
	^ classification at: index
]

