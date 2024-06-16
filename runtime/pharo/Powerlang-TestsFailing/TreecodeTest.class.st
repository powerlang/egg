Class {
	#name : 'TreecodeTest',
	#superclass : 'TestCase',
	#instVars : [
		'method'
	],
	#pools : [
		'AstBindingTypes',
		'AstNodeTypes'
	],
	#category : 'Powerlang-TestsFailing-SExpressions',
	#package : 'Powerlang-TestsFailing',
	#tag : 'SExpressions'
}

{ #category : 'private' }
TreecodeTest >> compile: source in: aSpecies [
	^SCompiler compile: source in: aSpecies
]

{ #category : 'private' }
TreecodeTest >> decode: anArray of: aCompiledMethod [
	| decoder |
	decoder := TreecodeDecoder new
		stream: anArray readStream;
		method: aCompiledMethod.
	^decoder decodeMethod
]

{ #category : 'private' }
TreecodeTest >> encode: source [
	^self encode: source in: UndefinedObject
]

{ #category : 'private' }
TreecodeTest >> encode: source in: aSpecies [
	| spec compiler |
	spec := EggBootstrapImage kernelSpec at: aSpecies name.
	compiler := SCompiler forClass: spec.
	method := compiler compile: source.
	^ method treecodes
]

{ #category : 'private' }
TreecodeTest >> test010emptyMethod [
	| treecodes root |
	treecodes := self encode: 'm'.
	self assert: treecodes equals: {MethodId}.
	root := self decode: treecodes of: method.
	self assert: root isMethod; assert: root statements isEmpty
]

{ #category : 'private' }
TreecodeTest >> test020encodeFalse [
	| treecodes root identifier |
	treecodes := self encode: 'm false'.
	self assert: treecodes equals: {MethodId. {IdentifierId. FalseId}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	identifier := root statements first.
	self
		assert: identifier isVariable;
		assert: identifier binding isLiteral;
		assert: identifier binding value equals: false
]

{ #category : 'private' }
TreecodeTest >> test020encodeNil [
	| treecodes root identifier |
	treecodes := self encode: 'm nil'.
	self assert: treecodes equals: {MethodId. {IdentifierId. NilId}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	identifier := root statements first.
	self
		assert: identifier isVariable;
		assert: identifier binding isLiteral;
		assert: identifier binding value equals: nil
]

{ #category : 'private' }
TreecodeTest >> test020encodeSelf [
	| treecodes root identifier |
	treecodes := self encode: 'm self'.
	self assert: treecodes equals: {MethodId. {IdentifierId. SelfId}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	identifier := root statements first.
	self assert: identifier isVariable; assert: identifier binding isSelf
]

{ #category : 'private' }
TreecodeTest >> test020encodeTrue [
	| treecodes root identifier |
	treecodes := self encode: 'm true'.
	self assert: treecodes equals: {MethodId. {IdentifierId. TrueId}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	identifier := root statements first.
	self
		assert: identifier isVariable;
		assert: identifier binding isLiteral;
		assert: identifier binding value equals: true
]

{ #category : 'private' }
TreecodeTest >> test021encodeClassVar [
	| treecodes root identifier |
	treecodes := self encode: 'm Flags' in: Class.
	self assert: treecodes equals: {MethodId. {IdentifierId. DynamicVarId. 1}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	identifier := root statements first.
	self
		assert: identifier isVariable;
		assert: identifier binding isClassVar;
		assert: identifier binding association class equals: Association;
		assert: identifier binding association key equals: 'Flags'
]

{ #category : 'private' }
TreecodeTest >> test021encodeInstVar [
	| treecodes root identifier |
	treecodes := self encode: 'm name' in: Class.
	self assert: treecodes = {MethodId. {IdentifierId. DynamicVarId. 6}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size = 1.
	identifier := root statements first.
	self
		assert: identifier isVariable;
		assert: identifier binding isInstVar;
		assert: identifier binding index = 6
]

{ #category : 'private' }
TreecodeTest >> test021encodePoolVar [
	| treecodes root identifier |
	treecodes := self encode: 'm Pointers' in: Class.
	self assert: treecodes = {MethodId. {IdentifierId. DynamicVarId. 1}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size = 1.
	identifier := root statements first.
	self
		assert: identifier isVariable;
		assert: identifier binding isPoolVar;
		assert: identifier binding association class = Association;
		assert: identifier binding association key = 'Pointers';
		assert: identifier binding association value = 16r200
]

{ #category : 'private' }
TreecodeTest >> test022encodeReturn [
	| treecodes root return identifier |
	treecodes := self encode: 'm ^self'.
	self assert: treecodes equals: {MethodId. {ReturnId. true. {IdentifierId. SelfId}}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	return := root statements first.
	self assert: return isReturn.
	identifier := return expression.
	self assert: identifier isVariable; assert: identifier binding isSelf
]

{ #category : 'private' }
TreecodeTest >> test023encodeClass [
	| treecodes root return identifier |
	treecodes := self encode: 'm ^Array'.
	self
		assert: treecodes
			= {MethodId. {ReturnId. true. {IdentifierId. DynamicVarId. 1}}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size = 1.
	return := root statements first.
	self assert: return isReturn.
	identifier := return expression.
	self
		assert: identifier isVariable;
		assert: identifier binding isClassBinding;
		assert: identifier binding association key = #Array;
		assert: identifier binding association value = Array
]

{ #category : 'private' }
TreecodeTest >> test024encodeLiteral [
	| treecodes root literal |
	treecodes := self encode: 'm #foo'.
	self assert: treecodes equals: {MethodId. {LiteralId. 1}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	literal := root statements first.
	self
		assert: literal isLiteral;
		assert: literal value equals: #foo
]

{ #category : 'private' }
TreecodeTest >> test030encodeUnaryMessage [
	| treecodes root return message identifier |
	treecodes := self encode: 'm ^self foo'.
	self
		assert: treecodes
			equals: {MethodId. {ReturnId. true. {MessageId. 1. {IdentifierId. SelfId}}}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	return := root statements first.
	self assert: return isReturn.
	message := return expression.
	self assert: message isMessage.
	identifier := message receiver.
	self
		assert: message arguments isEmpty;
		assert: identifier isVariable;
		assert: identifier binding isSelf
]

{ #category : 'private' }
TreecodeTest >> test035encodeBinaryMessage [
	| treecodes root return message receiver argument |
	treecodes := self encode: 'm ^self foo: true'.
	self
		assert: treecodes
			equals: {MethodId. {ReturnId. true. {MessageId. 1. {IdentifierId. SelfId}. {IdentifierId. TrueId}}}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	return := root statements first.
	self assert: return isReturn.
	message := return expression.
	self assert: message isMessage.
	receiver := message receiver.
	argument := message arguments first.
	self
		assert: receiver isVariable;
		assert: receiver binding isSelf;
		assert: argument isVariable;
		assert: argument binding isLiteral;
		assert: argument binding value equals: true
]

{ #category : 'private' }
TreecodeTest >> test036encodeTernaryMessage [
	| treecodes root return message receiver arg1 arg2 |
	treecodes := self encode: 'm ^self foo: true bar: false'.
	self
		assert: treecodes equals: {MethodId. {ReturnId. true. {MessageId. 1.
					{IdentifierId. SelfId}.
					{IdentifierId. TrueId}.
					{IdentifierId. FalseId}}}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size equals: 1.
	return := root statements first.
	self assert: return isReturn.
	message := return expression.
	self assert: message isMessage.
	receiver := message receiver.
	arg1 := message arguments first.
	arg2 := message arguments second.
	self
		assert: receiver isVariable;
		assert: receiver binding isSelf;
		assert: arg1 isVariable;
		assert: arg1 binding isLiteral;
		assert: arg1 binding value equals: true;
		assert: arg2 isVariable;
		assert: arg2 binding isLiteral;
		assert: arg2 binding value equals: false
]

{ #category : 'private' }
TreecodeTest >> test050instVarAssignment [
	| treecodes root assignment assignee expression |
	treecodes := self encode: 'm name := true' in: Class.
	self
		assert: treecodes
			= {MethodId. {AssignmentId. {IdentifierId. DynamicVarId. 6}. {IdentifierId. TrueId}}}.
	root := self decode: treecodes of: method.
	self
		assert: root isMethod;
		assert: root statements size = 1.
	assignment := root statements first.
	self
		assert: assignment isAssignment;
		assert: assignment assignees size equals: 1.
	assignee := assignment assignees first.
	expression := assignment expression.
	self
		assert: assignee isVariable;
		assert: assignee binding isInstVar;
		assert: assignee binding index equals: 6;
		assert: expression isVariable;
		assert: expression binding isLiteral;
		assert: expression binding value equals: true
]
