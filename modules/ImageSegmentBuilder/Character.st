"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Character }

{ #category : #'*snapshotting' }
Character >> asSymbolicReference [
	^SymbolicReference character: self.
]

{ #category : #'*snapshotting' }
Character >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == Kernel
]
