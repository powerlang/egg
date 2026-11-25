'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #SmalltalkScannerTest category: #'Compiler.Tests'!
TestCase subclass: #SmalltalkScannerTest
	instanceVariableNames: 'scanner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Compiler.Tests'!
!SmalltalkScannerTest commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!SmalltalkScannerTest methodsFor:  'setup' stamp: 'KenD 28/Jun/2026 13:27:41'!
setUp
	super setUp.
	scanner := SCompiler new smalltalkScanner
! !

!SmalltalkScannerTest methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:41'!
test0xNotation
	| node |
	node := SCompiler new smalltalkParser parseExpression: '0x10'.
	self assert: node statements first value = 16.
	node := SCompiler new smalltalkParser parseExpression: '0X10'.
	self assert: node statements first value = 16
! !

!SmalltalkScannerTest methodsFor:  'arrays' stamp: 'KenD 28/Jun/2026 13:27:41'!
testArrayStart
	| node |
	scanner on: '#()'.
	node := scanner next.
	self
		assert: (node is: #'#(');
		assert: node source = '#('.
	scanner on: '#['.
	node := scanner next.
	self
		assert: (node is: #'#[');
		assert: node source = '#['.
	scanner on: '#''hello'''.
	node := scanner next.
	self
		assert: node value = #hello;
		assert: node source = '#''hello'''
! !

!SmalltalkScannerTest methodsFor:  'strings' stamp: 'KenD 28/Jun/2026 13:27:41'!
testBinary
	| node |
	scanner on: '-
		--
		---
		==>
		~!!|\/%&*+=><'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'-';
		assert: node source = '-'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'--';
		assert: node source = '--'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'---';
		assert: node source = '---'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'==>';
		assert: node source = '==>'.
	node := scanner next.
	self
		assert: node isBinary;
		assert: node value = #'~!!|\/%&*+=><';
		assert: node source = '~!!|\/%&*+=><'
! !

!SmalltalkScannerTest methodsFor:  'symbols' stamp: 'KenD 28/Jun/2026 13:27:41'!
testBinarySymbol
	| node |
	scanner on: '#='.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node hasSymbol;
		assert: node value = #'='
! !

!SmalltalkScannerTest methodsFor:  'strings' stamp: 'KenD 28/Jun/2026 13:27:41'!
testCharacter
	| node |
	scanner on: '$a$b'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = $a;
		assert: node source = '$a'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = $b;
		assert: node source = '$b'
! !

!SmalltalkScannerTest methodsFor:  'colons' stamp: 'KenD 28/Jun/2026 13:27:41'!
testColon
	| node |
	scanner on: ':a'.
	node := scanner next.
	self
		assert: (node is: $:);
		assert: node source = ':'.
	node := scanner next.
	self
		assert: node value = 'a';
		assert: node source = 'a'.
	scanner on: ':='.
	node := scanner next.
	self
		assert: node isAssignment;
		assert: node source = ':='
! !

!SmalltalkScannerTest methodsFor:  'colons' stamp: 'KenD 28/Jun/2026 13:27:41'!
testColon2
	| node |
	scanner on: '::'.
	node := scanner next.
	self
		assert: node class = SStringToken;
		assert: node source = '::'
! !

!SmalltalkScannerTest methodsFor:  'comments' stamp: 'KenD 28/Jun/2026 13:27:41'!
testComment
	| node |
	scanner on: '"comment"a'.
	node := scanner next.
	self
		assert: node isComment;
		assert: node value = 'comment';
		assert: node source = '"comment"'.
	scanner on: '"comment"'.
	node := scanner next.
	self
		assert: node isComment;
		assert: node source = '"comment"';
		assert: node position = 1.
	scanner on: 'a"comment"'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a';
		assert: node source = 'a'.
	node := scanner next.
	self
		assert: node isComment;
		assert: node position = ('a' size + 1)
! !

!SmalltalkScannerTest methodsFor:  'symbols' stamp: 'KenD 28/Jun/2026 13:27:41'!
testDashStartingSymbol
	| node |
	scanner on: '#++'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'++';
		assert: node source = '#++'.
	scanner on: '#//'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'//';
		assert: node source = '#//'.
	scanner on: '#--'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'--';
		assert: node source = '#--'.
	scanner on: '#+-'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'+-';
		assert: node source = '#+-'
! !

!SmalltalkScannerTest methodsFor:  'strings' stamp: 'KenD 28/Jun/2026 13:27:41'!
testEmpty
	scanner on: ''.
	self assert: scanner next isEnd
! !

!SmalltalkScannerTest methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:41'!
testFloat
	| node |
	scanner on: '0.1'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 0.1;
		assert: node source = '0.1'.
	scanner on: '0.1e-35'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 0.1e-35;
		assert: node source = '0.1e-35'
! !

!SmalltalkScannerTest methodsFor:  'identifiers' stamp: 'KenD 28/Jun/2026 13:27:41'!
testIdentifier
	| node |
	scanner on: 'a'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a';
		assert: node source = 'a'.
	scanner on: ' a1'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a1';
		assert: node source = 'a1'.
	scanner on: '_a'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = '_a';
		assert: node source = '_a'.
	scanner on: 'a_1b'.
	node := scanner next.
	self
		assert: node isNameToken;
		assert: node value = 'a_1b';
		assert: node source = 'a_1b'
! !

!SmalltalkScannerTest methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:41'!
testInteger
	| node |
	scanner on: '0 12 -35'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 0;
		assert: node source = '0'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 12;
		assert: node source = '12'.
	node := scanner next.
	self
		deny: node isNumberNode;
		assert: (node is: #'-');
		assert: node source = '-'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 35;
		assert: node source = '35'
! !

!SmalltalkScannerTest methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:41'!
testIntegerRadix
	| node |
	scanner on: '16rFA2'.
	node := scanner next.
	self
		assert: node isNumberNode;
		assert: node value = 16rFA2;
		assert: node source = '16rFA2'
! !

!SmalltalkScannerTest methodsFor:  'identifiers' stamp: 'KenD 28/Jun/2026 13:27:41'!
testKeyword
	| node node2 |
	scanner on: 'a:'.
	node := scanner next.
	self
		assert: node isKeyword;
		assert: node value = 'a:';
		assert: node source = 'a:'.
	scanner on: 'ab:cd:'.
	node := scanner next.
	node2 := scanner next.
	self
		assert: node isKeyword;
		assert: node value = 'ab:';
		assert: node source = 'ab:';
		assert: node2 isKeyword;
		assert: node2 value = 'cd:';
		assert: node2 source = 'cd:'
! !

!SmalltalkScannerTest methodsFor:  'symbols' stamp: 'KenD 28/Jun/2026 13:27:41'!
testNumericSymbol
	scanner on: '#35'.
	self assert: scanner next value = '35' asSymbol
! !

!SmalltalkScannerTest methodsFor:  'strings' stamp: 'KenD 28/Jun/2026 13:27:41'!
testString
	| node quote |
	scanner on: '' storeString.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = '';
		assert: node source = (String with: $' with: $').
	scanner on: 'Hello World!!' storeString.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = 'Hello World!!';
		assert: node source = 'Hello World!!' storeString.
	quote := String with: $'.
	scanner on: quote storeString.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = quote;
		assert: node source = quote storeString
! !

!SmalltalkScannerTest methodsFor:  'symbols' stamp: 'KenD 28/Jun/2026 13:27:41'!
testSymbol
	| node |
	scanner on: '#-'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'-';
		assert: node source = '#-'.
	scanner on: '#a:'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #a:;
		assert: node source = '#a:'.
	scanner on: '#-!!'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #'-!!';
		assert: node source = '#-!!'.
	scanner on: '#a:b:'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #a:b:;
		assert: node source = '#a:b:'.
	scanner on: '#a:b'.
	node := scanner next.
	self
		assert: node isLiteral;
		assert: node value = #a:;
		assert: node source = '#a:'.
	node := scanner next.
	self assert: node value = 'b'; assert: node source = 'b'
! !

!SmalltalkScannerTest methodsFor:  'unicode' stamp: 'KenD 28/Jun/2026 13:27:41'!
testUnicodeScanning
	"#knownIssue: depends on Character class>>value: path that resolves UnicodeLibrary,
	 which is not yet defined in the egg Kernel. Re-enable once UnicodeLibrary is ported."
	| next three tensor |
	#knownIssue.
	self assert: false.
	scanner on: '3 + 4' asWideString.
	self assert: scanner next value = 3.
	next := scanner next.
	self
		assert: next value == #'+';
		assert: scanner next value = 4.
	scanner on: '3' asWideString , 8855 asCharacter asString , '4' asWideString.
	three := scanner next.
	self assert: three value = 3.
	tensor := scanner next.
	self assert: tensor value = 8855 asCharacter asString asSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SmalltalkScannerTest class' category: #'Compiler.Tests'!
SmalltalkScannerTest class
	instanceVariableNames: ''!


