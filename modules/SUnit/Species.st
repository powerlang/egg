"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Species }

{ #category : '*SUnit' }
Species >> selectorsUpTo: aClass [
	| cls |
	^Array streamContents: [:strm | 
		cls := self.
		[
			cls notNil
				ifTrue: [cls methodDictionary keysAndValuesDo: [:k :v | strm nextPut: k]].
			cls == aClass]
			whileFalse: [cls := cls superclass]]
]

{ #category : '*SUnit' }
Species >> selectorsUpTo: aClass satisfying: aBlock [
	| cls set |
	set := IdentitySet new: 100.
	cls := self.
	[
		cls notNil ifTrue: [
			cls methodDictionary
				keysAndValuesDo: [:k :v | (aBlock value: k) ifTrue: [set add: k]]].
		cls == aClass]
		whileFalse: [cls := cls superclass].
	^set
]

{ #category : '*SUnit' }
Species >> sunitAllSelectors [
	| answer |
	answer := self superclass == Object
		ifTrue: [self selectors]
		ifFalse: [self superclass sunitAllSelectors addAll: self selectors; yourself].
	^answer asOrderedCollection
]

{ #category : '*SUnit' }
Species >> sunitSelectors [
	^self selectors asOrderedCollection sort
]

