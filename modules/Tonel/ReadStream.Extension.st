'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!


!ReadStream methodsFor:  '*TonelReader' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextWordOrNumber
	| c numeric token |
	[
		self atEnd ifTrue: [^nil].
		c := self next.
		c isAlphanumeric or: [c = $_]] whileFalse.
	numeric := c isDigit.
	token := String streamContents: [:strm | 
		strm nextPut: c.
		[
			self atEnd not and: [
				c := self next.
				numeric
					ifTrue: [c isDigit]
					ifFalse: [c isAlphanumeric or: [c = $_] or: [c = $.]]]]
			whileTrue: [strm nextPut: c]].
	(numeric and: [c isLetter]) ifTrue: [self skip: -1].
	^token first isDigit ifTrue: [token asInteger] ifFalse: [token]
! !


