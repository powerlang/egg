Class {
	#name : #SmalltalkSession,
	#superclass : #Object,
	#instVars : [
		'name',
		'username',
		'args'
	],
	#category : #Kernel
}

{ #category : #accessing }
SmalltalkSession >> commandLine [
	^CommandLine from: args
]

{ #category : #shutdown }
SmalltalkSession >> exit: code [
	[self shutdown] ensure: [Smalltalk os exit: code]
]

{ #category : #initialization }
SmalltalkSession >> initialize [
	super initialize.
	name := 'bee session'
]

{ #category : #accessing }
SmalltalkSession >> name [
	^name
]

{ #category : #accessing }
SmalltalkSession >> username [
	^username
]

{ #category : #accessing }
SmalltalkSession >> username: aString [
	username := aString
]


