"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ExternalHandle,
	#superclass : #ByteArray,
	#type : #bytes,
	#category : #FFI
}

{ #category : #'class initialization' }
ExternalHandle class >> new [
	^self new: WordSize
]
