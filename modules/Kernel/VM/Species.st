"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Species }

{ #category : '*Primitives' }
Species >> basicNew [
	<primitive: New>
]

{ #category : '*Primitives' }
Species >> basicNew: anInteger [
	<primitive: NewSized>
]

{ #category : '*Primitives' }
Species >> new [
	<primitive: New>
]

{ #category : '*Primitives' }
Species >> new: anInteger [
	<primitive: NewSized>
]

{ #category : '*Primitives' }
Species >> primitiveNewBytes: anInteger [
	<primitive: NewBytes>
]

