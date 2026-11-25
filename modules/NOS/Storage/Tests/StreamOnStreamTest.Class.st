'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #StreamOnStreamTest category: 'SqueakNOS-Storage-Tests'!
TestCase subclass: #StreamOnStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage-Tests'!
!StreamOnStreamTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testInnerStreamOnStream
	| changes size str1 str2 |
	changes := StandardFileStream fileNamed: 'testdata/test.changes'.
	size := changes size.	
	str1 := StreamOnStream on: changes from: changes size - 100 to: changes size.
	str1 setToEnd; nextPutAll: 'test'.
	str2 := StreamOnStream on: str1 offset: str1 size - 10 size: 10.
	str2 setToEnd; nextPutAll: 'test'.
	str2 := StreamOnStream on: str1 offset: str1 size - 10 size: 10.
	str2 position: 2; nextPutAll: 'aaaaaaaa'.
	changes flush; close; open: changes name forWrite: true.
	self assert: changes size = (size + 8 ).
	self assert: (changes contents asString last: 8) = 'aaaaaaaa'.
	
! !

!StreamOnStreamTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testInnerStreamOnStream2
	| changes size str1 str2 data contents |
	changes := StandardFileStream fileNamed: 'testdata/test.changes'.
	size := changes size.
	changes position: size - 10.
	data := (changes next: 10) asString.
	str1 := StreamOnStream
				on: changes
				offset: changes size - 100
				size: 100.
	str2 := StreamOnStream
				on: changes copy
				offset: changes size - 100
				size: 100.
	[str1 position: 90;
		 nextPutAll: 'testtestst'.
	str2 position: 0; nextPutAll: 'test'. 
	"self assert: (str2 next: 10) = 'testtestst'."
	changes flush; close; open: changes name forWrite: true.
	self assert: changes size = size.
	contents := changes contents asString.
	self assert: (contents last: 10) asString = 'testtestst'; assert: ((contents last: 100)first: 4) = 'test']
		ensure: [changes position: size - 10;
				 nextPutAll: data]
! !

!StreamOnStreamTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testRead
	| source |
	source := ReadStream on: 'this is a long string to read'.
	self assert: (StreamOnStream on: source from: 5 to: source size) contents asString = 'is a long string to read'.
	self assert: (StreamOnStream on: source from: 5 to: 14) contents asString = 'is a long'.
! !

!StreamOnStreamTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testSyncronization
	| changes size str1 str2 data contents |
	changes := StandardFileStream fileNamed: 'testdata/test.changes'.
	size := changes size.
	changes position: size - 10.
	data := (changes next: 10) asString.
	str1 := StreamOnStream
				on: changes
				offset: changes size - 100
				size: 100.
	[
		str1 position: 90;  nextPutAll: 'testtestst'; flush; close.
		contents := changes position: size - 10; next: 10.
		self assert: contents asString = 'testtestst'
	] ensure: [
		changes position: size - 10; nextPutAll: data; flush; close.
	]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StreamOnStreamTest class' category: 'SqueakNOS-Storage-Tests'!
StreamOnStreamTest class
	instanceVariableNames: ''!


