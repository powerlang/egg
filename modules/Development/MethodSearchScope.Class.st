'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #MethodSearchScope category: #Development!
Object subclass: #MethodSearchScope
	instanceVariableNames: 'class hierarchy project classSide'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!MethodSearchScope commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Quorum Software.
	See (MIT) license in root directory.
!

!MethodSearchScope methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:24'!
= aMethodSearchScope
	^self class == aMethodSearchScope class
		and: [class == aMethodSearchScope targetClass]
		and: [hierarchy == aMethodSearchScope targetHierarchy]
		and: [project == aMethodSearchScope targetProject]
		and: [classSide == aMethodSearchScope includesClassSide]
! !

!MethodSearchScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
class: aClass
	class := aClass.
	hierarchy := project := nil
! !

!MethodSearchScope methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:32:24'!
classesDo: aBlock
	class notNil ifTrue: [^aBlock value: class].
	hierarchy notNil
		ifTrue: [^hierarchy allSuperclasses reversed , hierarchy withAllSubclasses
			do: aBlock].
	project notNil ifTrue: [^project classes do: aBlock]
! !

!MethodSearchScope methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:32:24'!
collect: aBlock
	| result |
	result := OrderedCollection new.
	self do: [:m | result add: (aBlock evaluateWith: m)].
	^result
! !

!MethodSearchScope methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:32:24'!
do: aBlock
	self methodsDo: aBlock
! !

!MethodSearchScope methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:24'!
hash
	^self class hashWith: class with: hierarchy with: project with: classSide
! !

!MethodSearchScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
hierarchy: aClass
	hierarchy := aClass.
	class := project := nil
! !

!MethodSearchScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
includeClassSide: aBoolean
	classSide := aBoolean
! !

!MethodSearchScope methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
includesClassSide
	^classSide
! !

!MethodSearchScope methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	classSide := true.
	hierarchy := ProtoObject
! !

!MethodSearchScope methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isDefault
	^self = self class default
! !

!MethodSearchScope methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:32:24'!
methods
	| methods |
	methods := OrderedCollection new.
	self methodsDo: [:m | methods add: m].
	^methods
! !

!MethodSearchScope methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:32:24'!
methodsDo: aBlock
	project notNil ifTrue: [^project allMethods do: aBlock].
	self classesDo: [:c | 
		c methodDictionary values do: aBlock.
		classSide ifTrue: [c class methodDictionary values do: aBlock]]
! !

!MethodSearchScope methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
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
! !

!MethodSearchScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
project: aBeeProject
	project := aBeeProject.
	hierarchy := class := nil
! !

!MethodSearchScope methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:32:24'!
select: aBlock
	| result |
	result := OrderedCollection new.
	self do: [:m | (aBlock evaluateWith: m) ifTrue: [result add: m]].
	^result
! !

!MethodSearchScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
targetClass
	^class
! !

!MethodSearchScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
targetHierarchy
	^hierarchy
! !

!MethodSearchScope methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
targetProject
	^project
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MethodSearchScope class' category: #Development!
MethodSearchScope class
	instanceVariableNames: ''!

!MethodSearchScope class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
class: aClass
	^self new class: aClass
! !

!MethodSearchScope class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
default
	^self hierarchy: ProtoObject
! !

!MethodSearchScope class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
hierarchy: aClass
	^self new hierarchy: aClass
! !

!MethodSearchScope class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
project: aBeeProject
	^self new project: aBeeProject
! !


MethodSearchScope initialize!

