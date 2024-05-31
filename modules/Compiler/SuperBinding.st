Class {
	#name : #SuperBinding,
	#superclass : #SelfBinding,
	#category : #'Powerlang-Core-SCompiler-Bindings'
}

{ #category : #accessing }
SuperBinding >> encodeUsing: aTreecodeEmitter [
	aTreecodeEmitter encodeSuper
]

{ #category : #testing }
SuperBinding >> isSelf [
	^false
]

{ #category : #testing }
SuperBinding >> isSuper [
	^true
]

{ #category : #accessing }
SuperBinding >> name [
	^'super'
]
