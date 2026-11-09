"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #CompiledMethod }

{ #category : #'*snapshotting' }
CompiledMethod >> asSymbolicReference [
	^SymbolicReference forMethod: self
]

{ #category : #'*snapshotting' }
CompiledMethod >> shouldBeStoredIn: anObjectClosure [
	| installed |
	installed := self classBinding >> self selector.
	installed == self ifFalse: [^true].
	^anObjectClosure module == self module
		or: [anObjectClosure scope includes: self classBinding]
]
