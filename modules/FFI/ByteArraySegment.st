"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #ByteArraySegment }

{ #category : #accessing }
ByteArraySegment >> externalCopy [
	^ExternalMemory fromByteArray: self asByteArray
]



