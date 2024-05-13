"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #ProcessStack }

{ #category : #private }
ProcessStack class >> on: aProcess [
	^ProcessVMStack new process: aProcess
]
