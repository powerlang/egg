Class {
	#name : 'FalseBinding',
	#superclass : 'LiteralBinding',
	#category : 'Powerlang-SCompiler-Bindings',
	#package : 'Powerlang-SCompiler-Bindings'
}

{ #category : 'accessing' }
FalseBinding >> encodeUsing: aTreecodeEmitter [
	aTreecodeEmitter encodeFalse
]

{ #category : 'accessing' }
FalseBinding >> name [
	^'false'
]

{ #category : 'evaluating' }
FalseBinding >> value [
	^false
]
