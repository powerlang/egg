'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SSmalltalkScanner category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
Object subclass: #SSmalltalkScanner
	instanceVariableNames: 'compiler stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SSmalltalkScanner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildToken: aSmalltalkToken
	^self buildToken: aSmalltalkToken at: stream position
! !

!SSmalltalkScanner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildToken: aSmalltalkToken at: anInteger
	| string |
	string := stream copyFrom: anInteger to: stream position.
	^self buildToken: aSmalltalkToken at: anInteger with: string
! !

!SSmalltalkScanner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildToken: aSmalltalkToken at: anInteger with: anObject
	^aSmalltalkToken
		position: anInteger;
		value: anObject;
		end: stream position
! !

!SSmalltalkScanner methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canBeInIdentifier: aCharacter
	^compiler frontend canBeInIdentifier: aCharacter
! !

!SSmalltalkScanner methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canStartIdentifier: aCharacter
	(compiler frontend canStartIdentifier: aCharacter) ifFalse: [^false].
	aCharacter = $_
		ifTrue: [^stream peek ifNil: [false] ifNotNil: [:ch | ch asInteger >= 33]].
	^true
! !

!SSmalltalkScanner methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiler
	^compiler
! !

!SSmalltalkScanner methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiler: aSmalltalkCompiler
	compiler := aSmalltalkCompiler.
	compiler sourceCode ifNotNil: [:s | self sourceCode: s]
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
end
	^self buildToken: compiler endToken at: stream position + 1
! !

!SSmalltalkScanner methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
error: aString
	^self error: aString at: stream position
! !

!SSmalltalkScanner methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:40'!
error: aString at: anInteger
	^compiler error: aString at: anInteger
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
isBinary: aCharacter
	| code |
	aCharacter isNil ifTrue: [^false].
	code := aCharacter asInteger.
	code < 128 ifTrue: [
		^#($+ $- $< $> $= $* $/ $\ $| $& $~ $, $@ $% $? $!! $: $^)
			includes: aCharacter].
	^code > 255
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
next
	^self nextToken
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextArrayPrefix
	| string |
	string := stream copyFrom: stream position - 1 to: stream position.
	^self
		buildToken: compiler delimiterToken
		at: stream position - 1
		with: string
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextAssignment
	^self buildToken: compiler delimiterToken at: stream position with: #':='
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextBinarySelector
	stream back.
	^self
		buildToken: compiler stringToken
		at: stream position + 1
		with: self scanBinarySymbol
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextBinarySymbol
	^self
		buildToken: compiler literalNode
		at: stream position
		with: self scanBinarySymbol
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextColon
	| start char |
	start := stream position.
	char := stream peek.
	((char = Character space or: [char = Character tab]) and: [(stream peek: 2) second = $=]) ifTrue: [
		stream skip: 1.
		char := $=].
	char = $= ifTrue: [
		stream skip.
		^self nextAssignment position: start].
	^(self isBinary: stream peek)
		ifTrue: [self nextBinarySelector]
		ifFalse: [self nextSpecialCharacter]

! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextComment
	| start comment |
	start := stream position.
	[ stream atEnd not and:[stream peek !!== $"] ] whileTrue: [stream next].
	stream atEnd ifTrue: [self error: 'unfinished comment' at: start].
	stream position: start.
	comment := stream upTo: $".
	^self buildToken: compiler commentNode at: start with: comment

! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextIdentifierOrKeyword
	| start |
	start := stream position.
	self skipIdentifier.
	((stream peekFor: $:) and: [stream peekFor: $=]) ifTrue: [stream skip: -2].
	^self buildToken: compiler stringToken at: start
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextKeyword
	| start string |
	start := stream position + 1.
	self skipKeyword.
	string := stream copyFrom: start to: stream position.
	^self buildToken: compiler literalNode at: start - 1 with: string asSymbol
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextLiteralCharacter
	stream atEnd ifTrue: [^self error: 'character expected'].
	^self
		buildToken: compiler literalNode
		at: stream position
		with: stream next
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextLiteralString
	^self
		buildToken: compiler literalNode
		at: stream position
		with: self scanString reduced
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextNumber
	| parser assoc |
	stream skip: -1.
	parser := NumberParser new on: stream.
	assoc := parser next.
	parser error ifNotNil: [:e | ^self error: e key at: e value].
	^self
		buildToken: compiler numericLiteralNode
		at: assoc value start
		with: assoc key
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextQuotedSymbol
	| node |
	node := self nextLiteralString.
	^node beSymbol; position: node position - 1
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextSpecialCharacter
	| token |
	token := self buildToken: compiler delimiterToken.
	^token beCharacter
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextSymbolOrArrayPrefix
	| char |
	stream atEnd ifTrue: [self error: 'character expected'].
	char := stream peek.
	(self canBeInIdentifier: char) ifTrue: [^self nextKeyword].
	(self isBinary: char) ifTrue: [^self nextBinarySymbol].
	stream next.
	(char = $[ or: [char = $(]) ifTrue: [^self nextArrayPrefix].
	char = $' ifTrue: [^self nextQuotedSymbol].
	self error: 'character expected'
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextToken
	| first |
	first := self scanChar.
	first isNil ifTrue: [^self end].
	(self canStartIdentifier: first) ifTrue: [^self nextIdentifierOrKeyword].
	(first = $→ or: [first = $_]) ifTrue: [^self nextAssignment].
	first = $: ifTrue: [^self nextColon].
	first = $' ifTrue: [^self nextLiteralString].
	first = $$ ifTrue: [^self nextLiteralCharacter].
	first = $# ifTrue: [^self nextSymbolOrArrayPrefix].
	first = $" ifTrue: [^self nextComment].
	first isDigit ifTrue: [^self nextNumber].
	(first !!= $^ and: [first !!= $↑ and: [self isBinary: first]])
		ifTrue: [^self nextBinarySelector].
	^self nextSpecialCharacter
! !

!SSmalltalkScanner methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
on: aString
	stream := aString readStream.
	compiler notNil ifTrue: [compiler sourceCode: aString]
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
scanBinarySymbol
	| start symbol |
	start := stream position.
	self skipBinary.
	symbol := stream copyFrom: start + 1 to: stream position.
	^symbol asSymbol
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
scanChar
	^(stream skipSeparators; atEnd) ifFalse: [stream next]

! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
scanString
	| current start |
	start := current := stream position.
	^String streamContents: [:writer | 
		[| fragment |
			fragment := stream upTo: $'.
			writer nextPutAll: fragment.
			(current < stream position and: [(stream back; next) = $'])
				ifFalse: [self error: 'string end expected' at: start].
			stream peekFor: $']
			whileTrue: [
				writer nextPut: $'.
				current := stream position]]
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
skipBinary
	[self isBinary: stream peek] whileTrue: [stream next]
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
skipIdentifier
	| frontend |
	frontend := compiler frontend.
	[stream atEnd]
		whileFalse: [(frontend peekForIdentifier: stream) ifFalse: [^self]]
! !

!SSmalltalkScanner methodsFor:  'scanning' stamp: 'KenD 28/Jun/2026 13:27:40'!
skipKeyword
	| frontend continue pos |
	frontend := compiler frontend.
	[
		self skipIdentifier.
		continue := false.
		(stream peekFor: $:) ifTrue: [
			pos := stream position.
			stream atEnd
				ifFalse: [continue := frontend canStartIdentifier: stream peek]].
		continue] whileTrue.
	pos isNil ifFalse: [stream position: pos]
! !

!SSmalltalkScanner methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sourceCode: aString
	stream := aString readStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSmalltalkScanner class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSmalltalkScanner class
	instanceVariableNames: ''!


