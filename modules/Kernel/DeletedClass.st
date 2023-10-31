"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #DeletedClass,
	#superclass : #Class,
	#type : #variable,
	#category : #Kernel
}

{ #category : #testing }
DeletedClass class >> canBeDeleted [
	^false
]

{ #category : #services }
DeletedClass >> beDeleted [
	"
	Do nothing
	"
	
]

{ #category : #testing }
DeletedClass >> isDeleted [
	^true
]

