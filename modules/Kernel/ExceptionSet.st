"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ExceptionSet,
	#superclass : #Object,
	#instVars : [
		'exceptions'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ExceptionSet class >> with: aClass [
	^self new add: aClass
]

{ #category : #'instance creation' }
ExceptionSet class >> with: aClass with: bClass [
	^self new add: aClass; add: bClass; yourself
]

{ #category : #'instance creation' }
ExceptionSet class >> with: aClass withAll: classesCollection [
	^self new add: aClass; addAll: classesCollection; yourself
]

{ #category : #adding }
ExceptionSet >> , aClass [
	(exceptions includes: aClass) ifTrue: [^self].
	^self class with: aClass withAll: exceptions
]

{ #category : #adding }
ExceptionSet >> add: aClass [
	^exceptions add: aClass
]

{ #category : #adding }
ExceptionSet >> addAll: classesCollection [
	exceptions addAll: classesCollection
]

{ #category : #inquiries }
ExceptionSet >> includesException: anException [
	^exceptions anySatisfy: [:class | class includesException: anException]
]

{ #category : #initialization }
ExceptionSet >> initialize [
	super initialize.
	exceptions := Set new
]

