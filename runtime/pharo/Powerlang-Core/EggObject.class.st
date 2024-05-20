Class {
	#name : #EggObject,
	#superclass : #Object,
	#category : #'Powerlang-Core-Execution-LMR'
}

{ #category : #accessing }
EggObject >> at: index [
	"Return indexed value at given index, starting with 1. This CANNOT be 
	 used for accessing named slots (aka, instance variables), to access 
	 them use #instVarAt:"
	
	self subclassResponsibility  
]

{ #category : #accessing }
EggObject >> at: index put: value [
	"Set indexed value at given `index` to `value`. This CANNOT be used for 
	 setting named slots (aka, instance variables), to access them use 
	 #instVarAt:put:"
	
	self subclassResponsibility  
]

{ #category : #accessing }
EggObject >> isBytes [
	^ false
]

{ #category : #accessing }
EggObject >> isImmediate [
	^false
]

{ #category : #accessing }
EggObject >> pointersSize [
	^0
]
