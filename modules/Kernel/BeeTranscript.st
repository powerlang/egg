"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #BeeTranscript,
	#superclass : #Object,
	#instVars : [
		'out'
	],
	#category : #Kernel
}

{ #category : #'open/close' }
BeeTranscript >> close [
]

{ #category : #output }
BeeTranscript >> cr [
	self output: String cr
]


