"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #CharacterArray }

{ #category : #'ffi' }
CharacterArray >> externalCopy [
	^OS externalCopyOfString: self
]
