Class {
	#name : 'SSuperBinding',
	#superclass : 'SSelfBinding',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'testing' }
SSuperBinding >> isSelf [
	^false
]

{ #category : 'testing' }
SSuperBinding >> isSuper [
	^true
]

{ #category : 'testing' }
SSuperBinding >> printOn: aStream [
	aStream nextPutAll: 'SuperId'
]
