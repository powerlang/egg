"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Integer }

{ #category : #services }
Integer >> externalBytes [
	^ExternalMemory allocate: self
]

{ #category : #services }
Integer >> externalCharacters [
	^ExternalMemory allocate: self + 1 * 2
]

{ #category : #converting }
Integer >> pointedMemory [
	^ExternalMemory at: self
]



