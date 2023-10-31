"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #StarToken,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #Kernel
}

{ #category : #accessing }
StarToken class >> current [
	^current
]

{ #category : #initialization }
StarToken class >> initializeCurrent [
	current := self new
]

{ #category : #'double dispatching' }
StarToken >> matchFirstAfterStartOn: aMatchAlgorithm [
	aMatchAlgorithm matchFirstStar
]

{ #category : #'double dispatching' }
StarToken >> matchFirstOn: aMatchAlgorithm [
	aMatchAlgorithm matchFirstStar
]

{ #category : #'double dispatching' }
StarToken >> matchLastOn: aMatchAlgorithm [
	"
	do nothing
	"
	
]

{ #category : #printing }
StarToken >> printOn: aStream [
	aStream nextPut: $*
]

