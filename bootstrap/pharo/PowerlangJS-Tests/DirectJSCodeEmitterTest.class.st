Class {
	#name : #DirectJSCodeEmitterTest,
	#superclass : #TestCase,
	#category : #'PowerlangJS-Tests'
}

{ #category : #tests }
DirectJSCodeEmitterTest >> compile: aString [
	^ self compile: aString in: UndefinedObject 

]

{ #category : #tests }
DirectJSCodeEmitterTest >> compile: methodSource in: aBehavior [
	| compiler method |
	compiler := OpalCompiler new.
	compiler
		class: aBehavior;
		source: methodSource.
		method := compiler compile.
	method putSource: methodSource withPreamble: [ :f | 
		f
			cr;
			nextPut: $!;
			nextChunkPut: 'OCompiler method';
			cr ].
	^method
]

{ #category : #tests }
DirectJSCodeEmitterTest >> compileAndTranspile: aString [

	| method |
	method := self compile: aString.
	^ self transpile: method 
]

{ #category : #tests }
DirectJSCodeEmitterTest >> test010emptyMethod [
	| code |
	code := self compileAndTranspile: 'foo'.
	self assert: code equals: '	foo() {
		return this;
	}

'
]

{ #category : #tests }
DirectJSCodeEmitterTest >> test020returnSelf [
	| code |
	code := self compileAndTranspile: 'foo ^self'.
	self assert: code equals: '	foo() {
		return this;
	}

'
]

{ #category : #tests }
DirectJSCodeEmitterTest >> transpile: method [
	^ DirectJSCodeEmitter new
		  method: method;
		  transpile;
		  result
]
