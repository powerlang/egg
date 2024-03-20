"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessorScheduler,
	#superclass : #Object,
	#instVars : [
		'activeProcess',
		'queues'
	],
	#category : #Kernel
}

{ #category : #accessing }
ProcessorScheduler >> activeProcess [
	^activeProcess
]

{ #category : #priorities }
ProcessorScheduler >> initialize [
	activeProcess := Process new name: 'main process'
]
