Extension { #name : 'Object' }

{ #category : '*OCompiler-Core' }
Object >> isBinaryConstantOperation [
	^false
]

{ #category : '*OCompiler-Core' }
Object >> isBinaryVariableOperation [
	^false
]

{ #category : '*OCompiler-Core' }
Object >> isInstruction [
	^false
]

{ #category : '*OCompiler-Core' }
Object >> isTernaryOperation [
	^false
]

{ #category : '*OCompiler-Core' }
Object >> isUnaryOperation [
	^false
]

{ #category : '*OCompiler-Core' }
Object >> primitivePrintString [
	^self printString
]
