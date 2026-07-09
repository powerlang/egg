"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #ProcessorScheduler }

{ #category : #'*snapshotting' }
ProcessorScheduler >> asSymbolicReference [
	^SymbolicReference forMvarNamed: #Processor in: #Kernel
]

{ #category : #'*snapshotting' }
ProcessorScheduler >> shouldBeStoredIn: anObjectClosure [
	^anObjectClosure scope includes: self class
]
