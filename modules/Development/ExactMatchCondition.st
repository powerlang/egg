"
	Copyright (c) 202, Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ExactMatchCondition, 
	#superclass : #CodeSearchCondition, 
	#category : #Development
}

{#category : #private}
ExactMatchCondition >> compare: aString [
	^aString = text
]

{#category : #testing}
ExactMatchCondition >> isExactMatch [
	^true
]

{#category : #private}
ExactMatchCondition >> proposition [
	^'equals'
]

