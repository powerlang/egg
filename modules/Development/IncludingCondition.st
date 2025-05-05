"
	Copyright (c) 202,5 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #IncludingCondition, 
	#superclass : #CodeSearchCondition, 
	#category : #Development
}

{#category : #private}
IncludingCondition >> compare: aString [
	^aString includesString: text
]

{#category : #private}
IncludingCondition >> proposition [
	^'includes'
]

