"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Metaclass }

{ #category : #'*snapshotting' }
Metaclass >> asSymbolicReference [
	^SymbolicReference new token: {class module name. class name}; linker: #asMetaclass.
]

{ #category : #'*snapshotting' }
Metaclass >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure scope includes: class
]