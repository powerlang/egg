Class {
	#name : #EggMetacircularRuntimeTestResource,
	#superclass : #TestResource,
	#instVars : [
		'image',
		'bootstrapper'
	],
	#category : #'Powerlang-Tests-Bootstrap'
}

{ #category : #running }
EggMetacircularRuntimeTestResource >> bootstrapper [
	^bootstrapper ifNil: [ bootstrapper := image generateLMR ]

]

{ #category : #running }
EggMetacircularRuntimeTestResource >> runtime [
	^ self bootstrapper result
]

{ #category : #running }
EggMetacircularRuntimeTestResource >> setUp [
	super setUp.
	image := EggRingImage fromSpec
		wordSize: 8;
		genesis;
		bootstrap;
		fillClasses;
		fillSymbols
]
