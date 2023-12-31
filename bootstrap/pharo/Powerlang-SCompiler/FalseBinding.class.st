Class {
	#name : #FalseBinding,
	#superclass : #LiteralBinding,
	#category : #'Powerlang-SCompiler-Bindings'
}

{ #category : #accessing }
FalseBinding >> encodeUsing: anAstcodeEmitter [
	anAstcodeEmitter encodeFalse
]

{ #category : #accessing }
FalseBinding >> name [
	^'false'
]

{ #category : #evaluating }
FalseBinding >> value [
	^false
]
