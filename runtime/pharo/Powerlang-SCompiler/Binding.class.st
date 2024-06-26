Class {
	#name : 'Binding',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'Powerlang-SCompiler-Bindings',
	#package : 'Powerlang-SCompiler',
	#tag : 'Bindings'
}

{ #category : 'actions' }
Binding >> beReferencedFrom: aScriptNode [
	
]

{ #category : 'testing' }
Binding >> canBeAssigned [
	^true
]

{ #category : 'testing' }
Binding >> declaration [
	^self
]

{ #category : 'testing' }
Binding >> encodeUsing: aTreecodeEncoder [
	self ASSERT: false
]

{ #category : 'testing' }
Binding >> isArgument [
	^false
]

{ #category : 'testing' }
Binding >> isClassBinding [
	^false
]

{ #category : 'testing' }
Binding >> isClassVariable [
	^false
]

{ #category : 'testing' }
Binding >> isConstantBinding [
	^false
]

{ #category : 'testing' }
Binding >> isDynamic [
	^false
]

{ #category : 'testing' }
Binding >> isGlobal [
	^false
]

{ #category : 'testing' }
Binding >> isInStack [
	^false
]

{ #category : 'testing' }
Binding >> isInstVar [
	^false
]

{ #category : 'testing' }
Binding >> isLiteral [
	^false
]

{ #category : 'testing' }
Binding >> isLocal [
	^false
]

{ #category : 'testing' }
Binding >> isPoolVariableBinding [
	^false
]

{ #category : 'testing' }
Binding >> isSelf [
	^false
]

{ #category : 'testing' }
Binding >> isSelfOrSuper [
	^self isSelf or: [self isSuper]
]

{ #category : 'testing' }
Binding >> isSuper [
	^false
]

{ #category : 'testing' }
Binding >> isTemporary [
	^false
]

{ #category : 'testing' }
Binding >> literal [
	^nil
]

{ #category : 'accessing' }
Binding >> name [
	^name
]

{ #category : 'accessing' }
Binding >> name: aString [
	name := aString
]

{ #category : 'printing' }
Binding >> printNameOn: aStream [
		aStream
		print: name

]

{ #category : 'printing' }
Binding >> printOn: aStream [
	self printNameOn: aStream.
	aStream
		nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPutAll: ')'
]
