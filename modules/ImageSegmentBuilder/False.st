"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #False }

{ #category : #'*snapshotting' }
False >> asSymbolicReference [
	^SymbolicReference new token: #false
]

