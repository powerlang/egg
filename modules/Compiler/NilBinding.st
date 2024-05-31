Class {
	#name : #NilBinding,
	#superclass : #LiteralBinding,
	#category : #'Powerlang-Core-SCompiler-Bindings'
}

{ #category : #accessing }
NilBinding >> encodeUsing: aTreecodeEmitter [
	aTreecodeEmitter encodeNil
]

{ #category : #accessing }
NilBinding >> name [
	^'nil'
]

{ #category : #evaluating }
NilBinding >> value [
	^nil
]
