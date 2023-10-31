"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #AssertionFailure,
	#superclass : #Halt,
	#category : #Kernel
}

{ #category : #accessing }
AssertionFailure >> defaultDescription [
	^'assertion failed'
]

