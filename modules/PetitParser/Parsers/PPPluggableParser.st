"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPPluggableParser,
	#superclass : #PPParser,
	#instVars : [
		'block'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPPluggableParser class >> on: aBlock [
	^ self new initializeOn: aBlock
]

{ #category : #accessing }
PPPluggableParser >> block [
	"Answer the pluggable block."

	^ block
]

{ #category : #initialization }
PPPluggableParser >> initializeOn: aBlock [
	block := aBlock
]

{ #category : #parsing }
PPPluggableParser >> parseOn: aStream [
	| position result |
	position := aStream position.
	result := block value: aStream.
	result isPetitFailure
		ifTrue: [ aStream position: position ].
	^ result
]

