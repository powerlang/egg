Class {
	#name : #JSOptimizingMethodTranspiler,
	#superclass : #Object,
	#instVars : [
		'method',
		'ir'
	],
	#category : #'PowerlangJS-Core'
}

{ #category : #accessing }
JSOptimizingMethodTranspiler >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #accessing }
JSOptimizingMethodTranspiler >> transpile [
	| frontend emitter |
	frontend := OptimizingRBVisitor new.
	ir := frontend
		      method: method;
		      visit.
	emitter := OptimizingJSCodeEmitter new.
	^ emitter
		  method: method;
			ir: ir;
		  generate;
		  result
]
