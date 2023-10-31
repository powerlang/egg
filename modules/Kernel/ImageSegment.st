"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #ImageSegment,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #Kernel
}

{ #category : #accessing }
ImageSegment class >> load: filename [
	"TO BE IMPLEMENTED!"
	^nil
]

{ #category : #accessing }
ImageSegment >> name [
	^name
]

{ #category : #accessing }
ImageSegment >> name: aString [
	name := aString
]
