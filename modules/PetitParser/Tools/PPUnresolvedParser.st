"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPUnresolvedParser,
	#superclass : #PPParser,
	#category : #Tools
}

{ #category : #testing }
PPUnresolvedParser >> isUnresolved [
	^ true
]

{ #category : #parsing }
PPUnresolvedParser >> parseOn: aStream [
	self error: self printString , ' need to be resolved before execution.'
]

