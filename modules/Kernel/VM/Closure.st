"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Closure }

{ #category : '*Primitives' }
Closure >> value [
	<primitive: ClosureValue>
]

{ #category : '*Primitives' }
Closure >> evaluateAtomically [
	<primitive: ClosureValue>
]

{ #category : '*Primitives' }
Closure >> value: arg1 [
	<primitive: ClosureValueWithArgs>
]

{ #category : '*Primitives' }
Closure >> value: arg1 value: arg2 [
	<primitive: ClosureValueWithArgs>
]

{ #category : '*Primitives' }
Closure >> value: arg1 value: arg2 value: arg3[
	<primitive: ClosureValueWithArgs>
]

{ #category : '*Primitives' }
Closure >> evaluateWith: arg1 [
	<primitive: ClosureValueWithArgs>
]

{ #category : '*Primitives' }
Closure >> evaluateWith: arg1 with: arg2 [
	<primitive: ClosureValueWithArgs>
]

{ #category : '*Primitives' }
Closure >> argumentCount [
	<primitive: ClosureArgumentCount>
]

