"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #String }

{ #category : '*Primitives' }
String >> replaceFrom: start to: end with: collection startingAt: index [
	<primitive: StringReplaceFromToWithStartingAt>
	collection hasBytes
		ifTrue: [self
			replaceBytesFrom: start
			to: end
			with: collection
			startingAt: index]
		ifFalse: [super
			replaceFrom: start
			to: end
			with: collection
			startingAt: index]
]


