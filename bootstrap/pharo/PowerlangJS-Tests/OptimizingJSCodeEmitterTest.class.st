Class {
	#name : #OptimizingJSCodeEmitterTest,
	#superclass : #TestCase,
	#category : #'PowerlangJS-Tests'
}

{ #category : #tests }
OptimizingJSCodeEmitterTest >> compile: aString [
	^ self compile: aString in: UndefinedObject 

]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> compile: methodSource in: aBehavior [
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
OptimizingJSCodeEmitterTest >> compileAndTranspile: aString [

	| method |
	method := self compile: aString.
	^ self transpile: method 
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> compileAndTranspile: aString in: aBehavior [
	| method |
	method := self compile: aString in: aBehavior.
	^ self transpile: method
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test010emptyMethod [
	| code |
	code := self compileAndTranspile: 'foo'.
	self assert: code equals: '	foo() {
		return this;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test011returnSelf [
	| code |
	code := self compileAndTranspile: 'foo ^self'.
	self assert: code equals: '	foo() {
		return this;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test012returnNil [
	| code |
	code := self compileAndTranspile: 'foo ^nil'.
	self  assert: code equals: '	foo() {
		return null;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test013returnTrue [
	| code |
	code := self compileAndTranspile: 'foo ^true'.
	self assert: code equals: '	foo() {
		return true;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test014returnFalse [
	| code |
	code := self compileAndTranspile: 'foo ^false'.
	self assert: code equals: '	foo() {
		return false;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test015returnSymbol [
	| code |
	code := self compileAndTranspile: 'foo ^#foo'.
	self assert: code equals: '	foo() {
		return "foo";
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test016returnArgument [
	| code |
	code := self compileAndTranspile: 'foo: arg ^arg'.
	self assert: code equals: '	foo_(arg) {
		return arg;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test017returnTemporary [
	| code |
	code := self compileAndTranspile: 'foo | temp | ^temp'.
	self assert: code equals: '	foo() {
		return temp;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test018returnIVar [
	| code |
	code := self compileAndTranspile: 'foo ^x' in: Point.
	self assert: code equals: '	foo() {
		return this.x;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test020returnNullarySendResult [
	| code |
	code := self compileAndTranspile: 'm ^self foo' in: Point.
	self assert: code equals: '	m() {
		t1 = this.foo();
		return t1;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test021returnUnarySendResult [
	| code |
	code := self compileAndTranspile: 'm ^self foo: nil' in: Point.
	self assert: code equals: '	m() {
		t1 = this.foo_(null);
		return t1;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> test022returnBinarySendResult [
	| code |
	code := self compileAndTranspile: 'm ^self foo: nil bar: 123' in: Point.
	self assert: code equals: '	m() {
		t1 = this.foo_bar_(null, 123);
		return t1;
	}

'
]

{ #category : #tests }
OptimizingJSCodeEmitterTest >> transpile: method [
	^ JSOptimizingMethodTranspiler new
		  method: method;
		  transpile
]
