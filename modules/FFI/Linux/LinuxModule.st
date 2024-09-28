"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #LinuxModule,
	#superclass : #Module,
	#category : #FFI
}

{ #category : #services }
LinuxModule >> externalCopyOfString: aString [
	^Kernel utf8 externalCopyOf: aString
]
