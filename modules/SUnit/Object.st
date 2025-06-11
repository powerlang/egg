"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*SUnit' }
Object >> sunitAddDependent: anObject [
	self addDependent: anObject
]

{ #category : '*SUnit' }
Object >> sunitChanged: aspect [
	self changed: aspect
]

{ #category : '*SUnit' }
Object >> sunitRemoveDependent: anObject [
	self removeDependent: anObject
]

