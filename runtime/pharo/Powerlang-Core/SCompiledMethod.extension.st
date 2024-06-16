Extension { #name : 'SCompiledMethod' }

{ #category : '*Powerlang-Core' }
SCompiledMethod >> sexpressions [
	| decoder |
	decoder := TreecodeDecoder new
		stream: treecodes readStream;
		method: self.
	^decoder decodeMethod
]
