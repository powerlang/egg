"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TestFailure,
	#superclass : #Exception,
	#instVars : [
		'resumable'
	],
	#category : #SUnit
}

{ #category : #sunit }
TestFailure class >> sunitSignalWith: aString resumable: aBoolean [
	^self new description: aString; resumable: aBoolean; signal
]

{ #category : #testing }
TestFailure >> isResumable [
	^resumable notNil and: [resumable]
]

{ #category : #testing }
TestFailure >> resumable: aBoolean [
	resumable := aBoolean
]

