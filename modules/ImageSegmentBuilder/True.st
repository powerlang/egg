"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #True }

{ #category : #'*snapshotting' }
True >> asSymbolicReference [
	^SymbolicReference new token: #true.
]
