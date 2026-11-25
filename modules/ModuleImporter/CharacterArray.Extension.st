'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!CharacterArray methodsFor:  '*CodeSpecsImporter' stamp: 'KenD 28/Jun/2026 13:27:37'!
unixToMac
	| result |
	result := self species new: self size.
	self
		withIndexDo: [:c :i | c = Lf
			ifTrue: [result at: i put: Cr]
			ifFalse: [result at: i put: c]].
	^result
! !

!CharacterArray methodsFor:  '*CodeSpecsImporter' stamp: 'KenD 28/Jun/2026 13:27:37'!
dosToUnix
	^self species streamContents: [:s | | source |
		source := self readStream.
		[source atEnd] whileFalse: [| c |
			c := source next.
			c = Cr
				ifTrue: [
					s nextPut: Lf.
					source next]
				ifFalse: [s nextPut: c]]]
! !


