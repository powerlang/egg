"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #SimilarityCondition, 
	#superclass : #CodeSearchCondition, 
	#instVars : [
		'tolerance'
	], 
	#category : #Development
}

{#category : #private}
SimilarityCondition >> compare: aString [
	^(aString editDistanceTo: text) <= tolerance
]

{#category : #initialization}
SimilarityCondition >> initialize [
	super initialize.
	tolerance := 3
]

{#category : #testing}
SimilarityCondition >> isSimilarity [
	^true
]

{#category : #private}
SimilarityCondition >> proposition [
	^'is similar to'
]

