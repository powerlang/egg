"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Species }

{ #category : '*Compiling' }
Species >> compile: aString [
	| result |
	result := SCompiler compile: aString in: class.
	result method ifNotNil: [:m | m install ]
]


