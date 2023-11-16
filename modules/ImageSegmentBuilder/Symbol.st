"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Symbol }

{ #category : #'*snapshotting' }
Symbol >> asSymbolicReference [
	^SymbolicReference forSymbol: self
]

{ #category : #'*snapshotting' }
Symbol >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == Kernel
]
