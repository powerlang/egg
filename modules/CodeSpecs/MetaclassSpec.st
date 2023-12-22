"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #MetaclassSpec, 
	#superclass : #SpeciesSpec, 
	#instVars : [
		'class'
	], 
	#category : #CodeSpecs
}

{#category : #enumerating}
MetaclassSpec >> allSuperclassesDo: aBlock [
	| s c |
	class supername isNil ifTrue: [
		c := module resolveClass: 'Class'.
		c ifNil: [c := Class].
		c allSuperclassesDo: aBlock].
	s := self superclass.
	s isNil ifTrue: [^self].
	aBlock value: s.
	s allSuperclassesDo: aBlock]

{#category : #inquiries}
MetaclassSpec >> classVarNames [
	^class classVarNames]

{#category : #accessing}
MetaclassSpec >> instanceClass [
	^class]

{#category : #accessing}
MetaclassSpec >> instanceClass: aClassSpec [
	class := aClassSpec]

{#category : #testing}
MetaclassSpec >> isMetaclass [
	^true]

{#category : #inquiries}
MetaclassSpec >> metaMethods [
	^#()]

{#category : #inquiries}
MetaclassSpec >> name [
	^class name , ' class']

{#category : #inquiries}
MetaclassSpec >> sharedPools [
	^class sharedPools]

{#category : #inquiries}
MetaclassSpec >> superclass [
	^class superclass ifNotNil: [:c | c metaclass]]

{#category : #inquiries}
MetaclassSpec >> supername [
	^self superclass name]

