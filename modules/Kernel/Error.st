"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Error,
	#superclass : #Exception,
	#category : #Kernel
}

{ #category : #testing }
Error >> isResumable [
	^false
]

