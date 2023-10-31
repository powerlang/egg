"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CompiledExpression,
	#superclass : #CompiledMethod,
	#type : #variable,
	#category : #Kernel
}

{ #category : #queries }
CompiledExpression >> currentVersion [
	^self
]

{ #category : #evaluation }
CompiledExpression >> evaluate [
	^self executeOn: nil
]

{ #category : #accessing }
CompiledExpression >> isDoit [
	^self selector == #doit
]

{ #category : #testing }
CompiledExpression >> isExpression [
	^true
]

{ #category : #accessing }
CompiledExpression >> selector [
	^selector ifNil: [#doit]
]

