Class {
	#name : 'EggProcessSuspended',
	#superclass : 'Error',
	#instVars : [
		'process',
		'exception',
		'context'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : 'accessing' }
EggProcessSuspended >> backtrace [
	^context backtrace
]

{ #category : 'accessing' }
EggProcessSuspended >> context: anEvaluationContext [

	context := anEvaluationContext
]

{ #category : 'accessing' }
EggProcessSuspended >> exception [

	^ exception
]

{ #category : 'accessing' }
EggProcessSuspended >> exception: anObject [

	exception := anObject
]

{ #category : 'accessing' }
EggProcessSuspended >> process [

	^ process
]

{ #category : 'accessing' }
EggProcessSuspended >> process: anObject [

	process := anObject
]
