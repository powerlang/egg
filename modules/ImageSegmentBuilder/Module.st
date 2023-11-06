"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Module }

{ #category : #'*snapshotting' }
Module >> prepareForSnapshot: anImageSegmentWriter [
]

{ #category : #'*snapshotting' }
Module >> asSymbolicReference [
	^SymbolicReference new token: self name; linker: #asModule.
]

{ #category : #'*snapshotting' }
Module >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == self
]
