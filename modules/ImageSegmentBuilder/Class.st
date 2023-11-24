"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Class }

{ #category : #'*snapshotting' }
Class >> asSymbolicReference [
	^SymbolicReference forClass: self
]

{ #category : #'*snapshotting' }
Class >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure scope includes: self
]
