'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TonelWriterTest category: #'Tonel.Tests'!
TestCase subclass: #TonelWriterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tonel.Tests'!
!TonelWriterTest commentStamp: '<historical>' prior: 0!

	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
!

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testWriteClassProducesOutput
	| output |
	output := TonelWriter writeClass: TonelWriter.
	self assert: output notEmpty
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testWriteClassStartsWithClassType
	| output |
	output := TonelWriter writeClass: TonelWriter.
	self assert: (output includesString: 'Class {')
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testWriteClassContainsClassName
	| output |
	output := TonelWriter writeClass: TonelWriter.
	self assert: (output includesString: '#TonelWriter')
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testWriteClassContainsCategory
	| output |
	output := TonelWriter writeClass: TonelWriter category: 'Tonel'.
	self assert: (output includesString: '#Tonel')
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testWriteClassContainsMethods
	| output |
	output := TonelWriter writeClass: TonelWriter.
	self assert: (output includesString: 'TonelWriter >> ')
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testClassMethodsAppearBeforeInstanceMethods
	| output classMethodPos instanceMethodPos |
	output := TonelWriter writeClass: TonelWriter.
	classMethodPos := output indexOfString: 'TonelWriter class >> '.
	instanceMethodPos := output indexOfString: 'TonelWriter >> write ['.
	self assert: classMethodPos > 0.
	self assert: instanceMethodPos > 0.
	self assert: classMethodPos < instanceMethodPos
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testMethodsAreSortedBySelector
	| output lines methodLines selectors |
	output := TonelWriter writeClass: TonelWriter.
	lines := output lines.
	methodLines := lines select: [:line |
		(line includesString: 'TonelWriter >> ') and: [
			(line includesString: 'TonelWriter class >> ') not]].
	selectors := methodLines collect: [:line |
		| start rest space |
		start := line indexOfString: '>> '.
		rest := line copyFrom: start + 3.
		space := rest indexOf: $ .
		space = 0
			ifTrue: [rest trimBlanks]
			ifFalse: [(rest copyFrom: 1 to: space - 1) trimBlanks]].
	selectors size > 1 ifTrue: [
		1 to: selectors size - 1 do: [:i |
			self assert: (selectors at: i) <= (selectors at: i + 1)]]
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRoundTrip
	| output reader |
	output := TonelWriter writeClass: TonelWriter category: 'Tonel'.
	reader := TonelReader on: output readStream.
	reader read.
	self assert: true
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testReadMethodWithDollarDollarLiteral
	"A method body containing $$ followed by a special character
	 (like [ or ]) must not confuse the block terminator scanner."
	| input reader |
	input := 'Class { #name : #Foo, #superclass : #Object, #category : #X }

{ #category : #m }
Foo >> m [
	| c | c := $$. ^c == $[
]
'.
	reader := TonelReader on: input readStream.
	reader read.
	self assert: reader methods size equals: 1
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testReadMethodWithDollarDollarFollowedByBracket
	"After $$ the next character is a real source character that must be
	 honored for nesting. E.g. $$[:x|x] contains a real opening [ that the
	 scanner must count."
	| input reader method |
	input := 'Class { #name : #Foo, #superclass : #Object, #category : #X }

{ #category : #m }
Foo >> m [
	^$$ , [:x | x] value: 1
]
'.
	reader := TonelReader on: input readStream.
	reader read.
	self assert: reader methods size equals: 1.
	method := reader methods first.
	self assert: ((method at: #body) includesString: 'value: 1')
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testReadMethodBodyEndingWithDollarDollar
	"$$ is a complete character literal (the $ char). The next character
	 (in this case the closing ]) is a real source character, not escaped.
	 Scanners that blindly treat 'prev = $' as escaping the next position
	 will fail to terminate here."
	| input reader method |
	input := 'Class { #name : #Foo, #superclass : #Object, #category : #X }

{ #category : #m }
Foo >> m [
	^$$]
'.
	reader := TonelReader on: input readStream.
	reader read.
	self assert: reader methods size equals: 1.
	method := reader methods first.
	self assert: ((method at: #body) includesString: '$$')
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testReadUnterminatedBlockRaises
	"An unterminated method body must raise an error, not hang nor silently truncate."
	| input reader |
	input := 'Class { #name : #Foo, #superclass : #Object, #category : #X }

{ #category : #m }
Foo >> m [
	self foo.
'.
	reader := TonelReader on: input readStream.
	self should: [reader read] raise: Error
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRoundTripWithUnicodeBody
	"Non-ASCII characters in a method body must round-trip through the
	 reader without being lost or mangled."
	| stream input reader method body nch |
	nch := Character value: 241.
	stream := String new writeStream.
	stream nextPutAll: 'Class { #name : #Foo, #superclass : #Object, #category : #X }'; cr; cr.
	stream nextPutAll: '{ #category : #m }'; cr.
	stream nextPutAll: 'Foo >> m ['; cr.
	stream tab; nextPutAll: '^'''; nextPut: nch; nextPutAll: ''''; cr.
	stream nextPutAll: ']'; cr.
	input := stream contents.
	reader := TonelReader on: input readStream.
	reader read.
	self assert: reader methods size equals: 1.
	method := reader methods first.
	body := method at: #body.
	self assert: (body includes: nch)
! !

!TonelWriterTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
testWriteMethodFirstLineHasNoExtraTabs
	"Writer output for each method must start with `Class >> selector` at
	 column 0 (no leading tabs)."
	| output lines headerLines tab |
	output := TonelWriter writeClass: TonelWriter.
	lines := output lines.
	headerLines := lines select: [:line | line includesString: 'TonelWriter '].
	self assert: headerLines notEmpty.
	tab := Character tab asString.
	headerLines do: [:line |
		self deny: (line beginsWith: tab)]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TonelWriterTest class' category: #'Tonel.Tests'!
TonelWriterTest class
	instanceVariableNames: ''!


