"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #UndefinedObject }

{ #category : #'*snapshotting' }
UndefinedObject >> asSymbolicReference [
	^SymbolicReference new linker: #nil
]

{ #category : #'*snapshotting' }
UndefinedObject >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == Kernel
]
