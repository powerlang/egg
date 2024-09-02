Class {
	#name : #HelloWorldModule,
	#superclass : #Module,
	#instVars : [
		''
	],
	#category : #'Examples-HelloWorld'
}

{ #category : #spec }
HelloWorldModule >> imports [
	^{
		#Kernel -> #(Transcript)
	}
]

{ #category : #services }
HelloWorldModule >> main: arguments [
	Transcript show: 'Hello, World!'.
	^0
]
