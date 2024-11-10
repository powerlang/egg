"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #ReadStream}

{#category : '*TonelReader'}
ReadStream >> nextWordOrNumber [
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
]
