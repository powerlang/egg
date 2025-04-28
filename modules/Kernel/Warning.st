"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Warning,
	#superclass : #Notification,
	#category : #Kernel
}

{ #category : #actions }
Warning >> defaultAction [
	Kernel host logWarning: self description, String cr
]

