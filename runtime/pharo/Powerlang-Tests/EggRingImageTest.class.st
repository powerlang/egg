Class {
	#name : 'EggRingImageTest',
	#superclass : 'TestCase',
	#instVars : [
		'image'
	],
	#category : 'Powerlang-Tests-Bootstrap',
	#package : 'Powerlang-Tests',
	#tag : 'Bootstrap'
}

{ #category : 'tests' }
EggRingImageTest >> setUp [
	image := EggBootstrapImage fromSpec
		wordSize: 8;
		genesis
]

{ #category : 'tests' }
EggRingImageTest >> test010nil [
	| nilObj class classname |
	nilObj := image nil.
	class := image classNamed: #UndefinedObject.
	classname := class slotNamed: #name.
	self
		assert: nilObj size equals: 0;
		assert: nilObj classname equals: 'UndefinedObject';
		assert: classname asString 
			equals: 'UndefinedObject'
]

{ #category : 'tests' }
EggRingImageTest >> test020true [
	| trueObj class classname |
	trueObj := image true.
	class := image classNamed: #True.
	classname := class slotNamed: #name.
	self
		assert: trueObj size equals: 0;
		assert: trueObj classname equals: 'True';
		assert: classname asString equals: 'True'
]

{ #category : 'tests' }
EggRingImageTest >> test030false [
	| falseObj class classname |
	falseObj := image false.
	class := image classNamed: #False.
	classname := class slotNamed: #name.
	self
		assert: falseObj size equals: 0;
		assert: falseObj classname equals: 'False';
		assert: classname asString equals: 'False'
]

{ #category : 'tests' }
EggRingImageTest >> test040superclasses [
	|  proto object collection class metaproto |
	proto := image classNamed: #ProtoObject.
	object := image classNamed: #Object.
	collection := image classNamed: #Collection.
	class := image classNamed: #Class.
	metaproto := image metaclassFor: (image => #ProtoObject) metaclass.
	self
		assert: proto superclass equals: image nil;
		assert: object superclass equals: proto;
		assert: collection superclass equals: object;
		assert: metaproto superclass equals: class
]

{ #category : 'tests' }
EggRingImageTest >> test050metaclasses [
	| proto metaproto |
	proto := image classNamed: #ProtoObject.
	metaproto := image metaclassFor: (image => #ProtoObject) metaclass.
	self assert: metaproto instanceSide equals: proto
]
