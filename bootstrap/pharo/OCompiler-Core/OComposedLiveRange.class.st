"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OComposedLiveRange,
	#superclass : #OLiveRange,
	#instVars : [
		'ranges'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #unclassified }
OComposedLiveRange >> add: range [
	ranges add: range
]

{ #category : #unclassified }
OComposedLiveRange >> addAll: range [
	ranges addAll: range
]

{ #category : #unclassified }
OComposedLiveRange >> allDefinitions [
	^ranges gather: #allDefinitions
]

{ #category : #unclassified }
OComposedLiveRange >> allUses [
	^ranges gather: #allUses
]

{ #category : #unclassified }
OComposedLiveRange >> anyDefinition [
	^ranges last anyDefinition
]

{ #category : #unclassified }
OComposedLiveRange >> definitionsWithBlocksDo: aBlock [
	^ranges do: [:range | range definitionsWithBlocksDo: aBlock]
]

{ #category : #unclassified }
OComposedLiveRange >> endsAt: operation [
	^false
]

{ #category : #unclassified }
OComposedLiveRange >> expirationPoints [
	| definitions uses |
	definitions := self allDefinitions.
	uses := ranges gather: #usesWithBlocks.
	^uses
		select: [:use | definitions
			noneSatisfy: [:def | def livesAfter: use key orOutOf: use value]]
		thenCollect: #key
]

{ #category : #unclassified }
OComposedLiveRange >> initialize [
	ranges := OrderedCollection new
]

{ #category : #unclassified }
OComposedLiveRange >> isLiveAt: aBlock [
	^self allDefinitions
		anySatisfy: [:def | def livesAfter: aBlock orOutOf: aBlock]
]

{ #category : #unclassified }
OComposedLiveRange >> isSpilled [
	^ranges anySatisfy: #isSpilled
]

{ #category : #unclassified }
OComposedLiveRange >> printOn: aStream [
	| rangesStrings |
	rangesStrings := (ranges collect: #printString) gather: [:x | x , String cr].
	aStream nextPutAll: 'CLR: ' , String cr , rangesStrings
]

{ #category : #unclassified }
OComposedLiveRange >> simpleRanges [
	^ranges
]

{ #category : #unclassified }
OComposedLiveRange >> startsAt: operation [
	^ranges anySatisfy: [:range | range startsAt: operation]
]

{ #category : #unclassified }
OComposedLiveRange >> usesWithBlocksDo: aBlock [
	^ranges do: [:range | range usesWithBlocksDo: aBlock]
]
