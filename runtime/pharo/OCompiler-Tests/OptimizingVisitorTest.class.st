Class {
	#name : #OptimizingVisitorTest,
	#superclass : #TestCase,
	#category : #'OCompiler-Tests'
}

{ #category : #tests }
OptimizingVisitorTest >> build: methodSource [
	^self build: methodSource in: UndefinedObject

]

{ #category : #tests }
OptimizingVisitorTest >> build: methodSource in: aBehavior [
	| compiler visitor method |
	compiler := OpalCompiler new.
	compiler
		class: aBehavior;
		source: methodSource.
	visitor := OptimizingRBVisitor new.
	method := compiler compile.
	method putSource: methodSource withPreamble: [ :f | 
					f
						cr;
						nextPut: $!;
						nextChunkPut: 'OCompiler method';
						cr ].
	^ visitor
		method: method;
		visit
]

{ #category : #tests }
OptimizingVisitorTest >> test010emptyMethod [
	| bb act receiver ret |
	bb := self build: 'm ^self'.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
	ret := receiver next.
	self
		assert: ret isReturn;
		assert: ret source equals: receiver
]

{ #category : #tests }
OptimizingVisitorTest >> test020returnNil [
	| bb act receiver ret null |
	bb := self build: 'm ^nil'.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
	null := receiver next.
	self
		assert: null isConstant;
		assert: null value equals: nil.
	ret := null next.
	self
		assert: ret isReturn;
		assert: ret source equals: null
]

{ #category : #tests }
OptimizingVisitorTest >> test030returnSymbol [
	| bb act receiver ret foo |
	bb := self build: 'm ^#foo'.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
	foo := receiver next.
	self
		assert: foo isConstant;
		assert: foo value equals: #foo.
	ret := foo next.
	self
		assert: ret isReturn;
		assert: ret source equals: foo
]

{ #category : #tests }
OptimizingVisitorTest >> test040returnIVar [
	| bb act receiver ret foo |
	bb := self build: 'm ^x' in: Point.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
	foo := receiver next.
	self
		assert: foo isLoad;
		assert: foo name equals: #_basicAt:;
		assert: foo index equals: 'x'.
	ret := foo next.
	self
		assert: ret isReturn;
		assert: ret source equals: foo
]

{ #category : #tests }
OptimizingVisitorTest >> test041returnArgument [
	| bb act receiver ret foo |
	bb := self build: 'm: foo ^foo' in: Point.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
	foo := receiver next.
	self
		assert: foo isLoad;
		assert: foo name equals: #_basicAt:;
		assert: foo index equals: 'foo'.
	ret := foo next.
	self
		assert: ret isReturn;
		assert: ret source equals: foo
]

{ #category : #tests }
OptimizingVisitorTest >> test042returnTemporary [
	| bb act receiver ret foo |
	bb := self build: 'm | foo | ^foo' in: Point.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
"  not implemented yet: visitor initializes temps with nil
	null := receiver next.
	self assert: null isConstant; assert: null value equals: nil.
	foo := null next.
"
	foo := receiver next.
	self
		assert: foo isLoad;
		assert: foo name equals: #_basicAt:;
		assert: foo index equals: 'foo'.
	ret := foo next.
	self
		assert: ret isReturn;
		assert: ret source equals: foo
]

{ #category : #tests }
OptimizingVisitorTest >> test050returnNullarySendResult [
	| bb act receiver ret send |
	bb := self build: 'm ^self foo'.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
	send := receiver next.
	self 
		assert: send isMessageSend;
		assert: send selector equals: #foo;
		assert: send receiver equals: receiver;
		assert: send arguments isEmpty.
	ret := send next.
	self
		assert: ret isReturn;
		assert: ret source equals: send
]

{ #category : #tests }
OptimizingVisitorTest >> test050returnUnarySendResult [
	| bb act receiver ret arg send |
	bb := self build: 'm ^self foo: true'.
	self assert: bb class equals: OBasicBlock.
	act := bb next.
	self assert: act isActivation.
	receiver := act next.
	self
		assert: receiver isLoadImplicit;
		assert: receiver name equals: #self.
	arg := receiver next.
	self
		assert: arg isConstant;
		assert: arg value equals: true.
	send := arg next.
	self
		assert: send isMessageSend;
		assert: send selector equals: #foo:;
		assert: send receiver equals: receiver;
		assert: send arguments size equals: 1;
		assert: send arguments first equals: arg.
	ret := send next.
	self
		assert: ret isReturn;
		assert: ret source equals: send
]
