"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #CharacterArray}

{#category : '*CodeSpecsImporter'}
CharacterArray >> unixToMac [
	| result |
	result := self species new: self size.
	self
		withIndexDo: [:c :i | c = Lf
			ifTrue: [result at: i put: Cr]
			ifFalse: [result at: i put: c]].
	^result
]

{#category : '*CodeSpecsImporter'}
CharacterArray >> dosToUnix [
	^self species streamContents: [:s | | source |
		source := self readStream.
		[source atEnd] whileFalse: [| c |
			c := source next.
			c = Cr
				ifTrue: [
					s nextPut: Lf.
					source next]
				ifFalse: [s nextPut: c]]]
]