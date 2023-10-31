"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #IdentityDictionary,
	#superclass : #InlinedDictionary,
	#category : #Kernel
}

{ #category : #private }
IdentityDictionary >> equates: key1 with: key2 [
	^key1 == key2
]

{ #category : #private }
IdentityDictionary >> hashFor: object [
	^object basicHash * 16273
]

{ #category : #private }
IdentityDictionary >> keyCollector [
	^IdentitySet new: self size
]

