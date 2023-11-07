"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #KernelModule }

{ #category : #'*snapshotting' }
KernelModule >> prepareForSnapshot: aBuilder [
	aBuilder closure
		addBoundary: HashTable nilToken as:  SymbolicReference nilToken;
		addBoundary: Symbol symbolTable as: SymbolicReference symbolTable
]
