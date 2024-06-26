Class {
	#name : 'ObjectMirrorTest',
	#superclass : 'TestCase',
	#instVars : [
		'storage'
	],
	#category : 'Powerlang-TestsFailing-Metaphysics',
	#package : 'Powerlang-TestsFailing',
	#tag : 'Metaphysics'
}

{ #category : 'accessing' }
ObjectMirrorTest >> runtime [
	| vimage builder |
	vimage := EggBootstrapImage fromSpec
		wordSize: 8;
		genesis;
		bootstrap.
	builder := vimage builder.
	builder addGenesisObjects.
	^ Runtime
		forSimulating: EggBootstrapImage kernelSpec
		memory: builder writer write image
]

{ #category : 'private' }
ObjectMirrorTest >> test010nilObjectHandle [
	| runtime handle |
	runtime := self runtime.
	handle := runtime nil.
	self
		assert: handle isFixed;
		assert: handle isSmall;
		assert: handle size = 0
]

{ #category : 'private' }
ObjectMirrorTest >> test015nilObjectMirror [
	| runtime handle mirror |
	runtime := self runtime.
	handle := runtime nil.
	mirror := handle mirror.
	self
		assert: mirror = handle mirror;
		assert: mirror reflectsNil;
		deny: mirror reflectsInteger;
		assert: mirror size = 0;
		deny: mirror reflectsLargeObject;
		deny: mirror reflectsBytesObject;
		assert: mirror reflectedClass localName = 'UndefinedObject'
]

{ #category : 'private' }
ObjectMirrorTest >> test040UndefinedObjectMirror [
	| runtime nilMirror mirror |
	runtime := self runtime.
	nilMirror := runtime nil mirror.
	mirror := nilMirror reflectedBehavior methodDictionary.
	self
		assert: mirror reflectsMethodDictionary
]

{ #category : 'private' }
ObjectMirrorTest >> test100findKernel [
	| smalltalk |
	smalltalk := self runtime objectNamed: 'kernel'.
	self
		assert: smalltalk reflectedClass localName
		equals: 'Kernel'
]
