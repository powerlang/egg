"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #ByteArray }

{ #category : #'*instance creation' }
ByteArray class >> fromMemory: anExternalMemory length: anInteger [
	^self fromBytes: anExternalMemory length: anInteger
]

{ #category : #copying }
ByteArray >> copyToMemory: anExternalMemory [
	anExternalMemory replaceFrom: 1 to: self size with: self startingAt: 1
]

{ #category : #copying }
ByteArray >> externalCopy [
	^ExternalMemory fromByteArray: self
]

{ #category : #converting }
ByteArray >> pointedMemory [
	^ExternalMemory at: self
]


