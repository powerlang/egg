Class {
	#name : 'SExpressionEmulatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'builder',
		'writer',
		'runtime',
		'kernel'
	],
	#pools : [
		'AstBindingTypes',
		'AstNodeTypes'
	],
	#category : 'Powerlang-TestsFailing-Metaphysics',
	#package : 'Powerlang-TestsFailing',
	#tag : 'Metaphysics'
}

{ #category : 'tests' }
SExpressionEmulatorTest >> handleFor: anObjectMap [
	| oid |
	oid := writer offsetOf: anObjectMap.
	^runtime handleOn: oid

]

{ #category : 'tests' }
SExpressionEmulatorTest >> injectMethod: aTreecode selector: selector for: classname [
	^ builder
		newMethod: aTreecode
		selector: selector
		in: classname
		format: 0
		literals: #()
]

{ #category : 'tests' }
SExpressionEmulatorTest >> injectObject [
	^ builder newSlots: 'Object'
]

{ #category : 'tests' }
SExpressionEmulatorTest >> invoke: method with: object [
	| m receiver |
	m := self handleFor: method.
	receiver := self handleFor: object.
	^receiver mirror invoke: m mirror asMethodMirror with: #()
]

{ #category : 'running' }
SExpressionEmulatorTest >> setUp [
	super setUp.
	builder := EggBootstrapImage kernelSpec build
]

{ #category : 'tests' }
SExpressionEmulatorTest >> test100yourself [
	| object handle result |
	object := self injectObject.
	handle := builder emulator handleOn: object.
	result := handle maneuverer yourself.
	self
		assert: object == result
]

{ #category : 'running' }
SExpressionEmulatorTest >> write [
	writer := builder writer write.
	runtime := Runtime
		forSimulating: EggBootstrapImage kernelSpec
		memory: writer image
]
