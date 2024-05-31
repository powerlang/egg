Class {
	#name : #SelfBinding,
	#superclass : #Binding,
	#category : #'Powerlang-SCompiler-Bindings'
}

{ #category : #actions }
SelfBinding >> beReferencedFrom: aScriptNode [
	aScriptNode useSelf
]

{ #category : #testing }
SelfBinding >> canBeAssigned [
	^false
]

{ #category : #testing }
SelfBinding >> encodeUsing: aTreecodeEmitter [
	aTreecodeEmitter encodeSelf
]

{ #category : #testing }
SelfBinding >> isSelf [
	^true
]

{ #category : #accessing }
SelfBinding >> name [
	^'self'
]
