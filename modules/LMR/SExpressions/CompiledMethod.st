"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #CompiledMethod }

{ #category : '*Compiling' }
CompiledMethod >> sexpressions [
	| decoder |
	decoder := TreecodeDecoder new
		           stream: treecodes readStream;
		           method: self.
	^decoder decodeMethod
]


