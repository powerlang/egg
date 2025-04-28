Class {
	#name : #SmalltalkSession,
	#superclass : #Object,
	#instVars : [
		'name',
		'username',
		'args',
		'resources',
		'finalizer'
	],
	#category : #Kernel
}

{ #category : #accessing }
SmalltalkSession >> args [
	^args
]

{ #category : #accessing }
SmalltalkSession >> args: anArray [
	args := anArray
]

{ #category : #'startup/shutdown' }
SmalltalkSession >> closeExternalResources [
	resources do: [:object | object sessionShutdown]
]


{ #category : #'startup/shutdown' }
SmalltalkSession >> ephemeronsDo: aBlock [
	resources ephemeronsDo: aBlock.
	finalizer ephemeronsDo: aBlock.
]

{ #category : #shutdown }
SmalltalkSession >> exit: code [
	[self shutdown] ensure: [Kernel host exit: code]
]

{ #category : #accessing }
SmalltalkSession >> finalizer [
	^finalizer
]

{ #category : #initialization }
SmalltalkSession >> initialize [
	super initialize.
	name := 'egg session'.
	finalizer := WeakIdentitySet new.
	resources := WeakIdentitySet new
]

{ #category : #initialization }
SmalltalkSession >> initializeFinalizationBlocks [
	finalizer finalizer: [:object | object finalize].
	resources finalizer: [:object | object finalize]
]

{ #category : #accessing }
SmalltalkSession >> name [
	^name
]

{ #category : #initialization }
SmalltalkSession >> rehashWeakRegistries [
	resources rehash.
	finalizer rehash
]

{ #category : #accessing }
SmalltalkSession >> resourceRegistry [
	^resources
]

{ #category : #'startup/shutdown' }
SmalltalkSession >> startUp [
	self initializeFinalizationBlocks.
	resources do: [:object | object sessionStartup]
]

{ #category : #accessing }
SmalltalkSession >> username [
	^username
]

{ #category : #accessing }
SmalltalkSession >> username: aString [
	username := aString
]


