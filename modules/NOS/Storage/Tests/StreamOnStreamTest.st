Class {
	#name : #StreamOnStreamTest,
	#superclass : #TestCase,
	#category : #'SqueakNOS-Storage-Tests'
}

{ #category : #tests }
StreamOnStreamTest >> testInnerStreamOnStream [
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
	
]

{ #category : #'as yet unclassified' }
StreamOnStreamTest >> testInnerStreamOnStream2 [
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
]

{ #category : #'as yet unclassified' }
StreamOnStreamTest >> testRead [
	| source |
	source := ReadStream on: 'this is a long string to read'.
	self assert: (StreamOnStream on: source from: 5 to: source size) contents asString = 'is a long string to read'.
	self assert: (StreamOnStream on: source from: 5 to: 14) contents asString = 'is a long'.
]

{ #category : #'as yet unclassified' }
StreamOnStreamTest >> testSyncronization [
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
]
