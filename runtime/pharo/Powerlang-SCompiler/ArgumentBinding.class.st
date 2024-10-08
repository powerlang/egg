Class {
	#name : 'ArgumentBinding',
	#superclass : 'LocalBinding',
	#category : 'Powerlang-SCompiler-Bindings',
	#package : 'Powerlang-SCompiler',
	#tag : 'Bindings'
}

{ #category : 'instance creation' }
ArgumentBinding class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'actions' }
ArgumentBinding >> beInlined [
	environment := InlinedArgEnvironment new
]

{ #category : 'testing' }
ArgumentBinding >> canBeAssigned [
	^false
]

{ #category : 'actions' }
ArgumentBinding >> description [
	^'argument ' , name
]

{ #category : 'actions' }
ArgumentBinding >> encodeUsing: aTreecodeEncoder [
	aTreecodeEncoder encodeArgument: index env: environment
]

{ #category : 'testing' }
ArgumentBinding >> index: aNumber [
	index := aNumber.

]

{ #category : 'initialization' }
ArgumentBinding >> initialize [
	super initialize.
	environment := ArgumentEnvironment new
]

{ #category : 'testing' }
ArgumentBinding >> isArgument [
	^true
]

{ #category : 'actions' }
ArgumentBinding >> isInlined [
	^environment isInlinedArgument
]
