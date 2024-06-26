Class {
	#name : 'SCommentNode',
	#superclass : 'SParseNode',
	#instVars : [
		'value'
	],
	#category : 'Powerlang-SCompiler-Parser',
	#package : 'Powerlang-SCompiler',
	#tag : 'Parser'
}

{ #category : 'testing' }
SCommentNode >> isComment [
	^true
]

{ #category : 'accessing' }
SCommentNode >> value [
	^value
]

{ #category : 'accessing' }
SCommentNode >> value: aString [
	value := aString
]
