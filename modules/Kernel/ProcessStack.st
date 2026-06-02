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
		'bp',
		'env',
		'pc'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ProcessStack class >> on: aProcess [
	^self errorVMSpecific
]

{ #category : #services }
ProcessStack >> lastArgumentOf: frame [
	"
		Given the base index of a frame, then comes retaddr, then last argument passed in the invokation
	"
	^self at: frame + 2
]

{ #category : #services }
ProcessStack >> contextSwitchTo: next [
	self subclassResponsibility
]

{ #category : #services }
ProcessStack >> copyFrom: first to: last [
	| step |
	step := first < last ifTrue: [1] ifFalse: [-1].
	^(first to: last by: step) collect: [:i | self at: i].
]

{ #category : #services }
ProcessStack >> fillFrom: aContext [
	#CRITICAL.
	sp := aContext copyAllTo: self.
	env := aContext lastEnvironment
]

{ #category : #accessing }
ProcessStack >> bp [
	^bp
]

{ #category : #accessing }
ProcessStack >> sp [
	^sp
]

{ #category : #accessing }
ProcessStack >> pc [
	^pc
]

{ #category : #accessing }
ProcessStack >> env [
	^env
]

{ #category : #accessing }
ProcessStack >> env: anObject [
	env := anObject
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