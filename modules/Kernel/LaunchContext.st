"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #LaunchContext,
	#superclass : #Context,
	#instVars : [
		'arguments'
	],
	#category : #Kernel
}

{ #category : #accessing }
LaunchContext >> arguments [
	^arguments
]

{ #category : #accessing }
LaunchContext >> arguments: anArray [
	arguments := anArray
]

{ #category : #services }
LaunchContext >> copyAllTo: aProcessStack [
	| index base |
	index := aProcessStack bufferSize.
	arguments do: [:arg |
		aProcessStack at: index put: arg.
		index := index - 1].

	base := index - 1.
	aProcessStack
		pcAt: index put: 0 of: nil;
		bpAt: base put: 0.

	^self copyTo: aProcessStack at: index - 2
]

{ #category : #services }
LaunchContext >> previousEnvironment [
	^nil
]
