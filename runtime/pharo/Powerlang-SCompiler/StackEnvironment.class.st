Class {
	#name : 'StackEnvironment',
	#superclass : 'LocalEnvironment',
	#category : 'Powerlang-SCompiler-Bindings',
	#package : 'Powerlang-SCompiler',
	#tag : 'Bindings'
}

{ #category : 'accessing' }
StackEnvironment >> index [
	^nil
]

{ #category : 'private' }
StackEnvironment >> isStack [
	^true
]
