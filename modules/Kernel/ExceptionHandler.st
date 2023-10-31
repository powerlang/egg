"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ExceptionHandler,
	#superclass : #Object,
	#instVars : [
		'filter',
		'previous',
		'handlerBlock',
		'protectedBlock',
		'return'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ExceptionHandler class >> handle: exceptionClass with: handlerBlock during: userBlock [
	^self new handle: exceptionClass with: handlerBlock during: userBlock
]

{ #category : #inquiries }
ExceptionHandler class >> shouldBeHidden: aSymbol [
	^true
]

{ #category : #handling }
ExceptionHandler >> evaluateFor: anException [
	^handlerBlock argumentCount = 0
		ifTrue: [handlerBlock value]
		ifFalse: [handlerBlock value: anException]
]

{ #category : #activation }
ExceptionHandler >> evaluateProtectedBlock [
	return := [:result | ^result].
	^protectedBlock value
]

{ #category : #handling }
ExceptionHandler >> findHandlerFor: anException [
	| handler |
	handler := self.
	[handler notNil] whileTrue: [
		(handler handles: anException) ifTrue: [^handler].
		handler := handler nextHandler].
	^nil
]

{ #category : #handling }
ExceptionHandler >> handle: anException [
	| result |
	ActiveProcess
		useExceptionHandler: previous
		while: [result := self evaluateFor: anException].
	anException reset.
	self return: result
]

{ #category : #activation }
ExceptionHandler >> handle: exceptionClass with: hBlock during: pBlock [
	| result |
	filter := exceptionClass.
	handlerBlock := hBlock.
	protectedBlock := pBlock.
	previous := ActiveProcess exceptionHandler.
	ActiveProcess
		useExceptionHandler: self
		while: [[
			result := self evaluateProtectedBlock.
			self shouldRetry: result] whileTrue].
	^result
]

{ #category : #testing }
ExceptionHandler >> handles: anException [
	^filter includesException: anException
]

{ #category : #services }
ExceptionHandler >> nextHandler [
	^previous
]

{ #category : #services }
ExceptionHandler >> nextHandlerFor: anException [
	^previous notNil ifTrue: [previous findHandlerFor: anException]
]

{ #category : #handling }
ExceptionHandler >> retry [
	self return: self retryToken
]

{ #category : #accessing }
ExceptionHandler >> retryToken [
	^return
]

{ #category : #handling }
ExceptionHandler >> retryUsing: aBlock [
	protectedBlock := aBlock.
	self retry
]

{ #category : #handling }
ExceptionHandler >> return: result [
	return value: result
]

{ #category : #handling }
ExceptionHandler >> shouldRetry: anObject [
	^anObject == self retryToken
]

