Class {
	#name : #TrueBinding,
	#superclass : #LiteralBinding,
	#category : #'Powerlang-SCompiler-Bindings'
}

{ #category : #accessing }
TrueBinding >> encodeUsing: aTreecodeEmitter [
	aTreecodeEmitter encodeTrue
]

{ #category : #accessing }
TrueBinding >> name [
	^'true'
]

{ #category : #evaluating }
TrueBinding >> value [
	^true
]
