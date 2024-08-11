"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRFloat,
	#superclass : #Float,
	#category : #Kernel
}

{ #category : #'*instance creation' }
LMRFloat class >> new [
	^self memory newArrayedBytes: instanceBehavior size: 8.
]

