"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRObject,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #accessing }
LMRObject >> size [
	^self primitiveSize
]