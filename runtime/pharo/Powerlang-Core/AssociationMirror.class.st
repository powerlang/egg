Class {
	#name : 'AssociationMirror',
	#superclass : 'ObjectMirror',
	#category : 'Powerlang-Core-Mirrors',
	#package : 'Powerlang-Core',
	#tag : 'Mirrors'
}

{ #category : 'as yet unclassified' }
AssociationMirror >> key [
	^self getInstVarNamed: #key
]

{ #category : 'private' }
AssociationMirror >> structureType [
	^#Association
]

{ #category : 'as yet unclassified' }
AssociationMirror >> value [
	^self getInstVarNamed: #value
]
