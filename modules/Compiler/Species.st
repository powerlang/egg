"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Species }

{ #category : '*Compiling' }
Species >> compile: aString [
	| method |
	method := SCompiler compile: aString in: self.
	method ifNotNil: [method install]
]


