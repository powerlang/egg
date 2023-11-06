"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Class }

{ #category : #'*snapshotting' }
Class >> asSymbolicReference [
	^SymbolicReference new token: {self module name. self name}; linker: #asClass.
]

{ #category : #'*snapshotting' }
Class >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure scope includes: self
]
