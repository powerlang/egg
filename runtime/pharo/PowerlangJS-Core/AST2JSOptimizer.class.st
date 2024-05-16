"
This class modifies the ast nodes of a method to allow transpilation of more efficient code when writing JS.

The main idea is that it removes nodes such as:

`x := condition ifTrue: [a. b. c] ifFalse: [d. e. f]`

The problem with these nodes is that in JS if statements are not expressions, so 
there is no direct translation from things like `x := ifTrue:ifFalse:` to JS using `if` 
(using operator ? is only possible for simple cases).
The solution is to modify all places where the result of sending `ifX` is used as a value,
making the assignments be done in each branch of the ifs. For the previous case we generate:

`condition ifTrue: [a. b. x := c] ifFalse: [d. e. x := f]`

thanks to this, the transpiler will be able to generate something in the order of:

```
if (condition){
	a;
	b;
	x := c
} else {
	d;
	e;
	x := f
}
```

instead of the much more inefficient

`x = condition.ifTrue_ifFalse_(() => {a . b. return c}, () => {d. e. return f})`
"
Class {
	#name : #AST2JSOptimizer,
	#superclass : #Object,
	#instVars : [
		'ast',
		'method',
		'realBlocks'
	],
	#classInstVars : [
		'aCompiledMethod'
	],
	#category : #'PowerlangJS-Core'
}

{ #category : #visiting }
AST2JSOptimizer >> addTemporaryForConditionValue [

	(ast body hasTemporaryNamed: '_condition') ifFalse: [ 
		ast body addTemporaryNamed: '_condition' ]
]

{ #category : #visiting }
AST2JSOptimizer >> addTemporaryForReturnValue [
		(ast body hasTemporaryNamed: '_retval') ifFalse: [ ast body addTemporaryNamed: '_retval' ].

]

{ #category : #visiting }
AST2JSOptimizer >> convertIfNotNilArgument: anRBMessageNode [

	| condition variable assignment block arguments argument |
	block := anRBMessageNode arguments first.
	block arguments size = 1 ifFalse: [ ^ self ].
	condition := anRBMessageNode receiver.


	variable := RBVariableNode new
		            name: '_condition';
		            variable: TemporaryVariable new.

	self addTemporaryForConditionValue.
	anRBMessageNode receiver: variable copy.
	assignment := RBAssignmentNode variable: variable value: condition.
	anRBMessageNode parent addNode: assignment before: anRBMessageNode.

	arguments := block arguments.
	argument := arguments first.
	assignment := RBAssignmentNode variable: argument value: variable.
	arguments removeFirst. block body
		addTemporaryNamed: argument name;
		addNodeFirst: assignment
]

{ #category : #visiting }
AST2JSOptimizer >> inlineAssignmentOf: anRBBlockNode into: anRBVariableNode [

	| body last var assignment |
	body := anRBBlockNode body.
	last := body statements last.
	last isReturn ifTrue: [ ^self ].
	var := anRBVariableNode copy parent: nil.
	assignment := RBAssignmentNode variable: var value: last.
	body
		removeNode: last;
		addNode: assignment
]

{ #category : #visiting }
AST2JSOptimizer >> inlineIfAssignment: anRBAssignmentNode [

	| if variable nilval initial |
	if := anRBAssignmentNode value.
	variable := anRBAssignmentNode variable.
	self inlineAssignmentOf: if arguments first into: variable.

	nilval := RBLiteralValueNode value: nil.
	initial := RBAssignmentNode
		           variable: variable
		           value: nilval.
	anRBAssignmentNode parent
		addNode: initial before: anRBAssignmentNode;
		addNode: if before: anRBAssignmentNode;
		removeNode: anRBAssignmentNode
]

{ #category : #visiting }
AST2JSOptimizer >> inlineIfElseAssignment: anRBAssignmentNode [

	| if variable |
	if := anRBAssignmentNode value.
		variable := anRBAssignmentNode variable.
	self
		inlineAssignmentOf: if arguments first into: variable;
		inlineAssignmentOf: if arguments second into: variable.
	anRBAssignmentNode parent
		addNode: if before: anRBAssignmentNode;
		removeNode: anRBAssignmentNode
]

{ #category : #visiting }
AST2JSOptimizer >> inlineIfElseImplicitReturn: if [

	| variable |
	variable := RBVariableNode new
		            name: '_retval';
		            variable: TemporaryVariable new.
	self addTemporaryForReturnValue;
		inlineAssignmentOf: if arguments first into: variable;
		inlineAssignmentOf: if arguments second into: variable.

	if parent addNode: variable
]

{ #category : #visiting }
AST2JSOptimizer >> inlineIfElseReturn: anRBReturnNode [

	| if variable |
	if := anRBReturnNode value.

	variable := RBVariableNode new
		            name: '_retval';
		            variable: TemporaryVariable new.

	self addTemporaryForReturnValue;
		inlineAssignmentOf: if arguments first into: variable;
		inlineAssignmentOf: if arguments second into: variable.

	anRBReturnNode value: variable copy.
	anRBReturnNode parent addNode: if before: anRBReturnNode
]

{ #category : #visiting }
AST2JSOptimizer >> inlineIfImplicitReturn: if [

	| variable nilval initial |
	variable := RBVariableNode new
		            name: '_retval';
		            variable: TemporaryVariable new.
	self addTemporaryForReturnValue; inlineAssignmentOf: if arguments first into: variable.

	nilval := RBLiteralValueNode value: nil.
	initial := RBAssignmentNode variable: variable value: nilval.
	if parent addNode: initial before: if.

	if parent addNode: variable
]

{ #category : #visiting }
AST2JSOptimizer >> inlineIfReturn: anRBReturnNode [

	| if variable nilval initial |
	if := anRBReturnNode value.


	variable := RBVariableNode new
		            name: '_retval';
		            variable: TemporaryVariable new.

	self addTemporaryForReturnValue;inlineAssignmentOf: if arguments first into: variable.

	nilval := RBLiteralValueNode value: nil.
	initial := RBAssignmentNode variable: variable value: nilval.
	anRBReturnNode parent addNode: initial before: anRBReturnNode.

	anRBReturnNode value: variable copy.
	anRBReturnNode parent addNode: if before: anRBReturnNode
]

{ #category : #visiting }
AST2JSOptimizer >> method: aCompiledMethod [

	method := aCompiledMethod
]

{ #category : #accessing }
AST2JSOptimizer >> transform [

	| nonlocals |
	ast := method parseTree.
	realBlocks := ast blockNodes.
	ast acceptVisitor: self.
	nonlocals := realBlocks anySatisfy: [ :b | 
		             b returnCount > 0 ].
	ast propertyAt: #hasNonLocal put: nonlocals.
	^ ast
]

{ #category : #visiting }
AST2JSOptimizer >> visitArgumentVariableNode: anRBArgumentNode [


]

{ #category : #visiting }
AST2JSOptimizer >> visitArrayNode: aRBArrayNode [


	aRBArrayNode statements
		do: [ :s | s acceptVisitor: self ]

]

{ #category : #visiting }
AST2JSOptimizer >> visitAssignmentNode: anRBAssignmentNode [

	| value selector |
	value := anRBAssignmentNode value.
	value acceptVisitor: self.

	value isMessage ifFalse: [ ^ self ].
	value isInlined ifFalse: [ ^ self ].
	selector := value selector value.

	(#(#ifTrue: #ifFalse: #ifNil: #ifNotNil:) includes: selector) ifTrue: [ 
		^ self inlineIfAssignment: anRBAssignmentNode ].

	(#(#ifTrue:ifFalse: #ifNil:ifNotNil:) includes: selector) ifTrue: [ 
		^ self inlineIfElseAssignment: anRBAssignmentNode ].

]

{ #category : #visiting }
AST2JSOptimizer >> visitBlockNode: anRBBlockNode [

	| statements last selector |
	statements := anRBBlockNode statements copy.
	statements do: [ :s | s acceptVisitor: self ].
	
	statements isEmpty ifTrue: [ ^self ].
	
	last := statements last.
	last isMessage ifFalse: [ ^ self ].
	last isInlined ifFalse: [ ^ self ].
	
	selector := last selector value.

	(#( #ifTrue: #ifFalse: #ifNil: #ifNotNil: ) includes: selector) 
		ifTrue: [ ^ self inlineIfImplicitReturn: last ].

	(#( #ifTrue:ifFalse: #ifNil:ifNotNil: ) includes: selector) ifTrue: [ 
		^ self inlineIfElseImplicitReturn: last ]
]

{ #category : #visiting }
AST2JSOptimizer >> visitCascadeMessageNode: anRBMessageNode [


	anRBMessageNode arguments
		do: [ :arg | arg acceptVisitor: self ]

]

{ #category : #visiting }
AST2JSOptimizer >> visitCascadeNode: anRBCascadeNode [

	| receiver messages |
	messages := anRBCascadeNode messages.
	receiver := messages first receiver.
	receiver acceptVisitor: self.
	messages do: [ :m | 
		self visitCascadeMessageNode: m].

]

{ #category : #visiting }
AST2JSOptimizer >> visitClassVariableNode: anRBVariableNode [

]

{ #category : #visiting }
AST2JSOptimizer >> visitGlobalVariableNode: anRBGlobalNode [

]

{ #category : #visiting }
AST2JSOptimizer >> visitInstanceVariableNode: anRBInstanceVariableNode [

]

{ #category : #visiting }
AST2JSOptimizer >> visitLiteralArrayNode: anRBLiteralArrayNode [

	anRBLiteralArrayNode contents
		do: [ :elem | elem acceptVisitor: self ]

]

{ #category : #visiting }
AST2JSOptimizer >> visitLiteralValueNode: anRBLiteralValueNode [


]

{ #category : #visiting }
AST2JSOptimizer >> visitMessageNode: anRBMessageNode [

	| selector |
	anRBMessageNode receiver acceptVisitor: self.
	anRBMessageNode arguments do: [ :arg | arg acceptVisitor: self ].
	anRBMessageNode isInlined ifFalse: [ ^ self ].

	selector := anRBMessageNode selector.
	(#( ifTrue: ifFalse: #ifTrue:ifFalse: ifNil: ifNotNil: #ifNil:ifNotNil: ) 
		 includes: selector) ifFalse: [ ^ self ].
	
	selector == #ifNotNil: ifTrue: [ self convertIfNotNilArgument: anRBMessageNode ].
	anRBMessageNode arguments do: [ :arg | 
		realBlocks remove: arg ifAbsent: nil ]
	

]

{ #category : #visiting }
AST2JSOptimizer >> visitMethodNode: anRBMethodNode [


	| statements |
	statements := anRBMethodNode statements copy.
	statements
		do: [ :s | 
			s acceptVisitor: self]
]

{ #category : #visiting }
AST2JSOptimizer >> visitReturnNode: anRBReturnNode [

	| value selector |
	value := anRBReturnNode value.
	value acceptVisitor: self.

	value isMessage ifFalse: [ ^ self ].
	value isInlined ifFalse: [ ^ self ].
	selector := value selector value.

	(#( #ifTrue: #ifFalse: #ifNil: #ifNotNil: ) includes: selector) 
		ifTrue: [ ^ self inlineIfReturn: anRBReturnNode ].

	(#( #ifTrue:ifFalse: #ifNil:ifNotNil: ) includes: selector) ifTrue: [ 
		^ self inlineIfElseReturn: anRBReturnNode ]
]

{ #category : #visiting }
AST2JSOptimizer >> visitSelfNode: aRBSelfNode [


]

{ #category : #visiting }
AST2JSOptimizer >> visitSuperNode: anRBSuperNode [

]

{ #category : #visiting }
AST2JSOptimizer >> visitTemporaryVariableNode: anRBTemporaryNode [

]
