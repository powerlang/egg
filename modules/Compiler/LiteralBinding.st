Class {
	#name : #LiteralBinding,
	#superclass : #Binding,
	#category : #'Powerlang-Core-SCompiler-Bindings'
}

{ #category : #testing }
LiteralBinding >> isLiteral [
	^true
]

{ #category : #decoding }
LiteralBinding class >> decodeUsing: anAstcodeDecoder [
	^self new
]
