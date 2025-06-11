"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Symbol }

{ #category : '*SUnit' }
Symbol >> sunitAsClass [
	^SUnitNameResolver classNamed: self
]

