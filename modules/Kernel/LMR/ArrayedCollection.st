"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRArrayedCollection,
	#superclass : #ArrayedCollection,
	#category : #Kernel
}

{ #category : '*Primitives' }
LMRArrayedCollection >> size [
	^self primitiveSize
]


