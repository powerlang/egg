"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Float }

{ #category : #copying }
Float >> externalCopy [
	^ExternalMemory fromByteArray: self
]


