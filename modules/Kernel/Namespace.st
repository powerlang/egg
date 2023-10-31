"
    Copyright (c) 2022 Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #Namespace,
	#superclass : #Dictionary,
	#instVars : [
		'parent'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Namespace class >> new [
	^super new
]

{ #category : #lookup }
Namespace >> _namespaceLookup: aSymbol [
	| table |
	table := namespace _basicAt: 2.
	2
		to: table _size
		do: [:j | | assoc |
			assoc := (table _basicAt: j).
			assoc == nil ifFalse: [
				assoc key == aSymbol
					ifTrue: [^table _basicAt: j + 1]]].
	^nil
]
