"
	Copyright (c) 2025, Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodSearchScope, 
	#superclass : #Object, 
	#instVars : [
		'class', 
		'hierarchy', 
		'project', 
		'classSide'
	], 
	#category : #Development
}

{#category : #'instance creation'}
MethodSearchScope class >> class: aClass [
	^self new class: aClass
]

{#category : #'instance creation'}
MethodSearchScope class >> default [
	^self hierarchy: ProtoObject
]

{#category : #'instance creation'}
MethodSearchScope class >> hierarchy: aClass [
	^self new hierarchy: aClass
]

{#category : #'instance creation'}
MethodSearchScope class >> project: aBeeProject [
	^self new project: aBeeProject
]

{#category : #comparing}
MethodSearchScope >> = aMethodSearchScope [
	^self class == aMethodSearchScope class
		and: [class == aMethodSearchScope targetClass]
		and: [hierarchy == aMethodSearchScope targetHierarchy]
		and: [project == aMethodSearchScope targetProject]
		and: [classSide == aMethodSearchScope includesClassSide]
]

{#category : #accessing}
MethodSearchScope >> class: aClass [
	class := aClass.
	hierarchy := project := nil
]

{#category : #enumerating}
MethodSearchScope >> classesDo: aBlock [
	class notNil ifTrue: [^aBlock value: class].
	hierarchy notNil
		ifTrue: [^hierarchy allSuperclasses reversed , hierarchy withAllSubclasses
			do: aBlock].
	project notNil ifTrue: [^project classes do: aBlock]
]

{#category : #enumerating}
MethodSearchScope >> collect: aBlock [
	| result |
	result := OrderedCollection new.
	self do: [:m | result add: (aBlock evaluateWith: m)].
	^result
]

{#category : #enumerating}
MethodSearchScope >> do: aBlock [
	self methodsDo: aBlock
]

{#category : #comparing}
MethodSearchScope >> hash [
	^self class hashWith: class with: hierarchy with: project with: classSide
]

{#category : #accessing}
MethodSearchScope >> hierarchy: aClass [
	hierarchy := aClass.
	class := project := nil
]

{#category : #accessing}
MethodSearchScope >> includeClassSide: aBoolean [
	classSide := aBoolean
]

{#category : #testing}
MethodSearchScope >> includesClassSide [
	^classSide
]

{#category : #initialization}
MethodSearchScope >> initialize [
	super initialize.
	classSide := true.
	hierarchy := ProtoObject
]

{#category : #testing}
MethodSearchScope >> isDefault [
	^self = self class default
]

{#category : #inquiries}
MethodSearchScope >> methods [
	| methods |
	methods := OrderedCollection new.
	self methodsDo: [:m | methods add: m].
	^methods
]

{#category : #enumerating}
MethodSearchScope >> methodsDo: aBlock [
	project notNil ifTrue: [^project allMethods do: aBlock].
	self classesDo: [:c | 
		c methodDictionary values do: aBlock.
		classSide ifTrue: [c class methodDictionary values do: aBlock]]
]

{#category : #printing}
MethodSearchScope >> printOn: aStream [
	class notNil ifTrue: [
		aStream
			nextPutAll: 'Methods in ';
			print: class;
			nextPutAll: ' class'.
		^self].
	hierarchy notNil ifTrue: [
		aStream
			nextPutAll: 'Methods in ';
			print: hierarchy;
			nextPutAll: ' hierarhcy'.
		^self].
	project notNil ifTrue: [
		aStream
			nextPutAll: 'Methods in ';
			print: project;
			nextPutAll: ' project'.
		^self].
	super printOn: aStream
]

{#category : #accessing}
MethodSearchScope >> project: aBeeProject [
	project := aBeeProject.
	hierarchy := class := nil
]

{#category : #enumerating}
MethodSearchScope >> select: aBlock [
	| result |
	result := OrderedCollection new.
	self do: [:m | (aBlock evaluateWith: m) ifTrue: [result add: m]].
	^result
]

{#category : #accessing}
MethodSearchScope >> targetClass [
	^class
]

{#category : #accessing}
MethodSearchScope >> targetHierarchy [
	^hierarchy
]

{#category : #accessing}
MethodSearchScope >> targetProject [
	^project
]

