"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #EndingCondition, 
	#superclass : #CodeSearchCondition, 
	#category : #Development
}

{#category : #private}
EndingCondition >> compare: aString [
	^aString endsWith: text
]

{#category : #private}
EndingCondition >> proposition [
	^'ends with'
]

