"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #EndOfStream,
	#superclass : #Error,
	#category : #Kernel
}

{ #category : #accessing }
EndOfStream >> defaultDescription [
	^'end of stream'
]

