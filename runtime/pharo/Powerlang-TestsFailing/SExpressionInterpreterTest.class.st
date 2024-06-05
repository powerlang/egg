Class {
	#name : 'SExpressionInterpreterTest',
	#superclass : 'TestCase',
	#instVars : [
		'builder',
		'writer',
		'runtime',
		'kernel'
	],
	#pools : [
		'AstBindingTypes',
		'SExpressionTypes'
	],
	#category : 'Powerlang-TestsFailing-Metaphysics',
	#package : 'Powerlang-TestsFailing',
	#tag : 'Metaphysics'
}

{ #category : 'tests' }
SExpressionInterpreterTest >> handleFor: anObjectMap [
	| oid |
	oid := writer offsetOf: anObjectMap.
	^runtime handleOn: oid

]

{ #category : 'tests' }
SExpressionInterpreterTest >> injectMethod: aTreecode selector: selector for: classname [
	^ builder
		newMethod: aTreecode
		selector: selector
		in: classname
		format: 0
		literals: #()
]

{ #category : 'tests' }
SExpressionInterpreterTest >> injectObject [
	^ builder newSlots: 'Object'
]

{ #category : 'tests' }
SExpressionInterpreterTest >> invoke: method with: object [
	| m receiver |
	m := self handleFor: method.
	receiver := self handleFor: object.
	^receiver mirror invoke: m mirror asMethodMirror with: #()
]

{ #category : 'running' }
SExpressionInterpreterTest >> setUp [
	super setUp.
	builder := VirtualImage kernelSpec build
]

{ #category : 'tests' }
SExpressionInterpreterTest >> test100empty [
	| object treecodes method result original |
	object := self injectObject.
	treecodes := {MethodId. {IdentifierId. SelfId}}.	"foo self"
	method := self injectMethod: treecodes selector: #foo for: 'Object'.
	self write.
	result := self invoke: method with: object.
	original := self handleFor: object.
	self
		assert: result localClassname equals: 'Object';
		assert: (result equals: original mirror)
]

{ #category : 'running' }
SExpressionInterpreterTest >> write [
	writer := builder writer write.
	runtime := Runtime
		forSimulating: VirtualImage kernelSpec
		memory: writer image
]
