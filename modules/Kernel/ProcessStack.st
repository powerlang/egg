"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessStack,
	#superclass : #Object,
	#instVars : [
		'process',
		'sp',
		'bp'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ProcessStack class >> on: aProcess [
	^self errorVMSpecific
]

{ #category : #services }
ProcessStack >> contextSwitchTo: next [
	self subclassResponsibility
]


{ #category : #services }
ProcessStack >> fillFrom: aContext [
	#CRITICAL.
	sp := (aContext copyAllTo: self).
	self at: sp put: aContext lastEnvironment
]

{ #category : #accessing }
ProcessStack >> process [
	^process
]

{ #category : #accessing }
ProcessStack >> process: aProcess [
	process := aProcess
]


{ #category : #services }
ProcessStack >> snapshot [
	self subclassResponsibility
]