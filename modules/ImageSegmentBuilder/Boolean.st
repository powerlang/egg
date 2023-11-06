"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Boolean }

{ #category : #'*snapshotting' }
Boolean >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure module == Kernel
]

