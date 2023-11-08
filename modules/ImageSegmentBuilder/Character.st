"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Character }

{ #category : #'*snapshotting' }
Character >> asSymbolicReference [
	^SymbolicReference new token: self asString; linker: #asCharacter.
]

{ #category : #'*snapshotting' }
Character >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == Kernel
]
