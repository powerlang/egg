"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #MessageNotUnderstood,
	#superclass : #Error,
	#instVars : [
		'message',
		'receiver'
	],
	#category : #Kernel
}

{ #category : #signaling }
MessageNotUnderstood class >> message: aMessage [
	^self new message: aMessage; signal
]

{ #category : #signaling }
MessageNotUnderstood class >> message: aMessage receiver: anObject [
	^self new message: aMessage; receiver: anObject; signal
]

{ #category : #actions }
MessageNotUnderstood >> defaultAction [
	Processor activeProcess
		suspendBecause: self defaultDescription
		resumable: true.
	^message performOn: receiver
]

{ #category : #accessing }
MessageNotUnderstood >> defaultDescription [
	| selector |
	message isNil ifTrue: [^super defaultDescription].
	selector := message selector ifNil: [^super defaultDescription].
	receiver isNil ifTrue: [^selector storeString , ' was sent to nil'].
	^selector storeString , ' not understood by ' , receiver printString
]

{ #category : #testing }
MessageNotUnderstood >> isResumable [
	^message notNil and: [receiver respondsTo: message selector]
]

{ #category : #accessing }
MessageNotUnderstood >> message [
	^message
]

{ #category : #accessing }
MessageNotUnderstood >> message: aMessage [
	message := aMessage
]

{ #category : #accessing }
MessageNotUnderstood >> receiver [
	^receiver
]

{ #category : #accessing }
MessageNotUnderstood >> receiver: anObject [
	receiver := anObject
]

