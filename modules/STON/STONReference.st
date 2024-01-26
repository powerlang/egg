"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #STONReference, 
	#superclass : #Object, 
	#instVars : [
		'index'
	], 
	#category : #STON
}

{#category : #'instance creation'}
STONReference class >> index: integer [
	^self new index: integer
]

{#category : #comparing}
STONReference >> = anObject [
	^self class == anObject class and: [self index = anObject index]
]

{#category : #comparing}
STONReference >> hash [
	^index hash
]

{#category : #accessing}
STONReference >> index [
	^index
]

{#category : #accessing}
STONReference >> index: integer [
	index := integer
]

{#category : #testing}
STONReference >> isStonReference [
	^true
]

{#category : #printing}
STONReference >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(; print: index; nextPut: $)
]

