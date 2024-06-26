Class {
	#name : 'SUndeclaredIdentifierError',
	#superclass : 'SCompilationError',
	#instVars : [
		'identifier',
		'assigned'
	],
	#category : 'Powerlang-SCompiler-Frontend',
	#package : 'Powerlang-SCompiler',
	#tag : 'Frontend'
}

{ #category : 'accessing-token' }
SUndeclaredIdentifierError >> assignment: aBoolean [
	assigned := aBoolean
]

{ #category : 'testing' }
SUndeclaredIdentifierError >> identifier [
	^ identifier
]

{ #category : 'testing' }
SUndeclaredIdentifierError >> isUndeclaredAccess [
	^assigned not
]

{ #category : 'testing' }
SUndeclaredIdentifierError >> isUndeclaredAssignment [
	^assigned
]

{ #category : 'testing' }
SUndeclaredIdentifierError >> stretch: aStretch [
	super stretch: aStretch.
	identifier := self source
]
