Class {
	#name : 'NilBinding',
	#superclass : 'LiteralBinding',
	#category : 'Powerlang-SCompiler-Bindings',
	#package : 'Powerlang-SCompiler-Bindings'
}

{ #category : 'accessing' }
NilBinding >> encodeUsing: aTreecodeEmitter [
	aTreecodeEmitter encodeNil
]

{ #category : 'accessing' }
NilBinding >> name [
	^'nil'
]

{ #category : 'evaluating' }
NilBinding >> value [
	^nil
]
