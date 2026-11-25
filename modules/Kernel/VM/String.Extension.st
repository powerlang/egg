'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!


!String methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: end with: collection startingAt: index
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
! !


