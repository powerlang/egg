"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #CharacterArray }

{ #category : #'ffi' }
CharacterArray >> externalCopy [
	^OS externalCopyOfString: self
]

{ #category : #'ffi' }
CharacterArray >> externalUTF16Copy [
	^Kernel utf16 externalCopyOf: self
]
