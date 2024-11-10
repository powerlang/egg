"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #CompiledMethod}

{#category : '*IDE'}
CompiledMethod >> references: anObject [
	| literal |
	1 to: self size do: [:i |
		literal := self at: i.
		anObject = literal ifTrue: [^true].
		(self literal: literal includes: anObject) ifTrue: [^true]].
	^false
]

{#category : '*IDE'}
CompiledMethod >> literal: literal includes: anObject [
	^literal class == Array and: [
		(literal includes: anObject)
			or: [literal anySatisfy: [:l | self literal: l includes: anObject]]]
]