"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Metaclass,
	#superclass : #Species,
	#instVars : [
		'class'
	],
	#category : #Kernel
}

{ #category : #accessing }
Metaclass >> name [
	^class name , ' class'
]

{ #category : #accessing }
Metaclass >> beSubclassOf: aClass [
	| md |	
	format := aClass format.
	superclass := aClass.
	md := MethodDictionary new: 2.
	instanceBehavior := Behavior with: md withAll: aClass instanceBehavior.
	instanceBehavior classBinding: self.
	class := self new
]

{ #category : #accessing }
Metaclass >> classVariables [
	^class classVariables
]

{ #category : #accessing }
Metaclass >> classVarNames [
	^class classVarNames
]

{ #category : #services }
Metaclass >> duplicateHierarchyFrom: aClass with: aClassCopy [
	^(class duplicateHierarchyFrom: aClass with: aClassCopy) class
]

{ #category : #comparing }
Metaclass >> hash [
	^class hash
]

{ #category : #accessing }
Metaclass >> instanceClass [
	^class
]

{ #category : #accessing }
Metaclass >> instanceClass: aClass [
	class := aClass
]

{ #category : #testing }
Metaclass >> isMetaclass [
	^true
]

{ #category : #accessing }
Metaclass >> name [
	^class name , ' class'
]

{ #category : #accessing }
Metaclass >> namespace [
	^class namespace
]

{ #category : #accessing }
Metaclass >> module [
	^class module
]

{ #category : #inquiries }
Metaclass >> shouldBeHidden: aSymbol [
	^class shouldBeHidden: aSymbol
]

{ #category : #accessing }
Metaclass >> subclasses [
	^class subclasses collect: [:cls | cls class]
]

{ #category : #accessing }
Metaclass >> subclasses: aCollection [
	"
	do nothing
	"
	
]

{ #category : #accessing }
Metaclass >> subclassesDo: aBlock [
	class isNil ifTrue: [^self].
	class subclasses
		select: [:cls | cls notNil]
		thenDo: [:cls | aBlock value: cls class]
]

{ #category : #accessing }
Metaclass >> subspecies [
	^self subclasses
]

{ #category : #accessing }
Metaclass >> subspeciesDo: aBlock [
	self subclassesDo: aBlock
]

{ #category : #accessing }
Metaclass >> symbol [
	^self name asSymbol
]

