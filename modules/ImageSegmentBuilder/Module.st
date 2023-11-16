"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Module }

{ #category : #'*snapshotting' }
Module >> asSymbolicReference [
	^SymbolicReference forModule: self
]

{ #category : #'*snapshotting' }
Module >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == self
]
