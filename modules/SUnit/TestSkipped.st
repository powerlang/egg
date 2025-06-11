"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TestSkipped,
	#superclass : #Notification,
	#category : #SUnit
}

{ #category : #testing }
TestSkipped >> isResumable [
	^false
]

