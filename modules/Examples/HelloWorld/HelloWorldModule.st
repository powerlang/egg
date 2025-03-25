Class {
	#name : #HelloWorldModule,
	#superclass : #Module,
	#category : #'Examples-HelloWorld'
}

{ #category : #spec }
HelloWorldModule >> imports [
	^{}
]

{ #category : #services }
HelloWorldModule >> main: arguments [
	Kernel log: 'Hello, World!', String cr.
	^0
]
