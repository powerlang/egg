"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPTokenParser,
	#superclass : #PPFlattenParser,
	#instVars : [
		'tokenClass'
	],
	#category : #Parsers
}

{ #category : #private }
PPTokenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ self tokenClass on: aCollection start: aStartInteger stop: aStopInteger
]

{ #category : #private }
PPTokenParser >> defaultTokenClass [
	^ PPToken
]

{ #category : #initialization }
PPTokenParser >> initialize [
	tokenClass := self defaultTokenClass
	
]

{ #category : #printing }
PPTokenParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' token'
]

{ #category : #accessing }
PPTokenParser >> tokenClass [
	^ tokenClass
]

{ #category : #accessing }
PPTokenParser >> tokenClass: aTokenClass [
	tokenClass := aTokenClass
]

