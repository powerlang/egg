"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Behavior }

{ #category : #'*snapshotting' }
Behavior >> asSymbolicReference [
	self DENY: self isInstanceBehavior.
	^SymbolicReference new token: {class module name. class name}; linker: #asBehavior.
]

{ #category : #'*snapshotting' }
Behavior >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure scope includes: class
]
