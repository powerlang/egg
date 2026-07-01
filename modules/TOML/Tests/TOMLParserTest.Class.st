'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TOMLParserTest category: #'TOML.Tests'!
TestCase subclass: #TOMLParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TOML.Tests'!
!TOMLParserTest commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!TOMLParserTest methodsFor:  'testing - strings' stamp: 'KenD 28/Jun/2026 13:27:37'!
testBasicString
	| result |
	result := TOMLParser parse: 'key = "hello"'.
	self assert: (result at: 'key') equals: 'hello'
! !

!TOMLParserTest methodsFor:  'testing - strings' stamp: 'KenD 28/Jun/2026 13:27:37'!
testStringEscapes
	| result |
	result := TOMLParser parse: 'key = "hello\nworld"'.
	self assert: (result at: 'key') equals: 'hello', Character lf asString, 'world'
! !

!TOMLParserTest methodsFor:  'testing - strings' stamp: 'KenD 28/Jun/2026 13:27:37'!
testEmptyString
	| result |
	result := TOMLParser parse: 'key = ""'.
	self assert: (result at: 'key') equals: ''
! !

!TOMLParserTest methodsFor:  'testing - strings' stamp: 'KenD 28/Jun/2026 13:27:37'!
testLiteralString
	| result |
	result := TOMLParser parse: 'key = ''no \escapes'''.
	self assert: (result at: 'key') equals: 'no \escapes'
! !

!TOMLParserTest methodsFor:  'testing - strings' stamp: 'KenD 28/Jun/2026 13:27:37'!
testMultilineBasicString
	| input result |
	input := 'key = """
hello
world"""'.
	result := TOMLParser parse: input.
	self assert: (result at: 'key') equals: 'hello', Character lf asString, 'world'
! !

!TOMLParserTest methodsFor:  'testing - strings' stamp: 'KenD 28/Jun/2026 13:27:37'!
testMultilineLiteralString
	| input result |
	input := 'key = ''''''
first
second'''''''.
	result := TOMLParser parse: input.
	self assert: (result at: 'key') equals: 'first', Character lf asString, 'second'
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testInteger
	| result |
	result := TOMLParser parse: 'key = 42'.
	self assert: (result at: 'key') equals: 42
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testNegativeInteger
	| result |
	result := TOMLParser parse: 'key = -17'.
	self assert: (result at: 'key') equals: -17
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testPositiveInteger
	| result |
	result := TOMLParser parse: 'key = +99'.
	self assert: (result at: 'key') equals: 99
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testZero
	| result |
	result := TOMLParser parse: 'key = 0'.
	self assert: (result at: 'key') equals: 0
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testUnderscoresInInteger
	| result |
	result := TOMLParser parse: 'key = 1_000_000'.
	self assert: (result at: 'key') equals: 1000000
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testHexInteger
	| result |
	result := TOMLParser parse: 'key = 0xff'.
	self assert: (result at: 'key') equals: 255
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testOctalInteger
	| result |
	result := TOMLParser parse: 'key = 0o77'.
	self assert: (result at: 'key') equals: 63
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testBinaryInteger
	| result |
	result := TOMLParser parse: 'key = 0b1010'.
	self assert: (result at: 'key') equals: 10
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testFloat
	| result |
	result := TOMLParser parse: 'key = 3.14'.
	self assert: ((result at: 'key') - 3.14) abs < 0.001
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testFloatWithExponent
	| result |
	result := TOMLParser parse: 'key = 1e10'.
	self assert: (result at: 'key') equals: 10000000000.0
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testNegativeFloat
	| result |
	result := TOMLParser parse: 'key = -0.5'.
	self assert: ((result at: 'key') + 0.5) abs < 0.001
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testInfinity
	| result |
	result := TOMLParser parse: 'key = inf'.
	self assert: (result at: 'key') equals: Float infinity
! !

!TOMLParserTest methodsFor:  'testing - numbers' stamp: 'KenD 28/Jun/2026 13:27:37'!
testNan
	| result |
	result := TOMLParser parse: 'key = nan'.
	self assert: (result at: 'key') isNaN
! !

!TOMLParserTest methodsFor:  'testing - booleans' stamp: 'KenD 28/Jun/2026 13:27:37'!
testTrue
	| result |
	result := TOMLParser parse: 'key = true'.
	self assert: (result at: 'key') equals: true
! !

!TOMLParserTest methodsFor:  'testing - booleans' stamp: 'KenD 28/Jun/2026 13:27:37'!
testFalse
	| result |
	result := TOMLParser parse: 'key = false'.
	self assert: (result at: 'key') equals: false
! !

!TOMLParserTest methodsFor:  'testing - arrays' stamp: 'KenD 28/Jun/2026 13:27:37'!
testEmptyArray
	| result |
	result := TOMLParser parse: 'key = []'.
	self assert: (result at: 'key') equals: #()
! !

!TOMLParserTest methodsFor:  'testing - arrays' stamp: 'KenD 28/Jun/2026 13:27:37'!
testIntegerArray
	| result |
	result := TOMLParser parse: 'key = [1, 2, 3]'.
	self assert: (result at: 'key') equals: #(1 2 3)
! !

!TOMLParserTest methodsFor:  'testing - arrays' stamp: 'KenD 28/Jun/2026 13:27:37'!
testMixedArray
	| result array |
	result := TOMLParser parse: 'key = [1, "two", true]'.
	array := result at: 'key'.
	self
		assert: array size equals: 3;
		assert: (array at: 1) equals: 1;
		assert: (array at: 2) equals: 'two';
		assert: (array at: 3) equals: true
! !

!TOMLParserTest methodsFor:  'testing - arrays' stamp: 'KenD 28/Jun/2026 13:27:37'!
testMultilineArray
	| input result |
	input := 'key = [
  1,
  2,
  3,
]'.
	result := TOMLParser parse: input.
	self assert: (result at: 'key') equals: #(1 2 3)
! !

!TOMLParserTest methodsFor:  'testing - tables' stamp: 'KenD 28/Jun/2026 13:27:37'!
testSimpleTable
	| input result |
	input := '[server]
host = "localhost"
port = 8080'.
	result := TOMLParser parse: input.
	self
		assert: ((result at: 'server') at: 'host') equals: 'localhost';
		assert: ((result at: 'server') at: 'port') equals: 8080
! !

!TOMLParserTest methodsFor:  'testing - tables' stamp: 'KenD 28/Jun/2026 13:27:37'!
testNestedTable
	| input result |
	input := '[a.b]
key = "value"'.
	result := TOMLParser parse: input.
	self assert: (((result at: 'a') at: 'b') at: 'key') equals: 'value'
! !

!TOMLParserTest methodsFor:  'testing - tables' stamp: 'KenD 28/Jun/2026 13:27:37'!
testInlineTable
	| result table |
	result := TOMLParser parse: 'point = {x = 1, y = 2}'.
	table := result at: 'point'.
	self
		assert: (table at: 'x') equals: 1;
		assert: (table at: 'y') equals: 2
! !

!TOMLParserTest methodsFor:  'testing - tables' stamp: 'KenD 28/Jun/2026 13:27:37'!
testArrayOfTables
	| input result products |
	input := '[[products]]
name = "Hammer"

[[products]]
name = "Nail"'.
	result := TOMLParser parse: input.
	products := result at: 'products'.
	self
		assert: products size equals: 2;
		assert: (products first at: 'name') equals: 'Hammer';
		assert: (products last at: 'name') equals: 'Nail'
! !

!TOMLParserTest methodsFor:  'testing - keys' stamp: 'KenD 28/Jun/2026 13:27:37'!
testBareKey
	| result |
	result := TOMLParser parse: 'bare-key_123 = "value"'.
	self assert: (result at: 'bare-key_123') equals: 'value'
! !

!TOMLParserTest methodsFor:  'testing - keys' stamp: 'KenD 28/Jun/2026 13:27:37'!
testQuotedKey
	| result |
	result := TOMLParser parse: '"quoted key" = "value"'.
	self assert: (result at: 'quoted key') equals: 'value'
! !

!TOMLParserTest methodsFor:  'testing - keys' stamp: 'KenD 28/Jun/2026 13:27:37'!
testDottedKey
	| result |
	result := TOMLParser parse: 'a.b.c = "deep"'.
	self assert: (((result at: 'a') at: 'b') at: 'c') equals: 'deep'
! !

!TOMLParserTest methodsFor:  'testing - comments' stamp: 'KenD 28/Jun/2026 13:27:37'!
testComment
	| input result |
	input := '# this is a comment
key = "value" # inline comment'.
	result := TOMLParser parse: input.
	self assert: (result at: 'key') equals: 'value'
! !

!TOMLParserTest methodsFor:  'testing - keys' stamp: 'KenD 28/Jun/2026 13:27:37'!
testMultipleKeyValues
	| input result |
	input := 'name = "test"
version = "1.0"
count = 5'.
	result := TOMLParser parse: input.
	self
		assert: (result at: 'name') equals: 'test';
		assert: (result at: 'version') equals: '1.0';
		assert: (result at: 'count') equals: 5
! !

!TOMLParserTest methodsFor:  'testing - errors' stamp: 'KenD 28/Jun/2026 13:27:37'!
testDuplicateKeyError
	self should: [
		TOMLParser parse: 'key = 1
key = 2'] raise: Error
! !

!TOMLParserTest methodsFor:  'testing - integration' stamp: 'KenD 28/Jun/2026 13:27:37'!
testEpmToml
	| input result project dependencies |
	input := '[project]
name = "myapp"
version = "0.1.0"
description = "A test app"

[dependencies]
JSON = ">=1.0"
STON = "~>2.0"'.
	result := TOMLParser parse: input.
	project := result at: 'project'.
	dependencies := result at: 'dependencies'.
	self
		assert: (project at: 'name') equals: 'myapp';
		assert: (project at: 'version') equals: '0.1.0';
		assert: (dependencies at: 'JSON') equals: '>=1.0';
		assert: (dependencies at: 'STON') equals: '~>2.0'
! !

!TOMLParserTest methodsFor:  'testing - integration' stamp: 'KenD 28/Jun/2026 13:27:37'!
testComplexDocument
	| input result owner database servers |
	input := 'title = "TOML Example"

[owner]
name = "John"

[database]
ports = [8001, 8001, 8002]
enabled = true

[servers.alpha]
ip = "10.0.0.1"

[servers.beta]
ip = "10.0.0.2"'.
	result := TOMLParser parse: input.
	owner := result at: 'owner'.
	database := result at: 'database'.
	servers := result at: 'servers'.
	self
		assert: (result at: 'title') equals: 'TOML Example';
		assert: (owner at: 'name') equals: 'John';
		assert: (database at: 'ports') equals: #(8001 8001 8002);
		assert: (database at: 'enabled') equals: true;
		assert: ((servers at: 'alpha') at: 'ip') equals: '10.0.0.1';
		assert: ((servers at: 'beta') at: 'ip') equals: '10.0.0.2'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TOMLParserTest class' category: #'TOML.Tests'!
TOMLParserTest class
	instanceVariableNames: ''!


