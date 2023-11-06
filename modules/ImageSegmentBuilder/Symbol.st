"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Symbol }

{ #category : #'*snapshotting' }
Symbol >> asSymbolicReference [
	^SymbolicReference new token: self; linker: #asSymbol.
]

{ #category : #'*snapshotting' }
Symbol >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == Kernel
]
