"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #BeginningCondition, 
	#superclass : #CodeSearchCondition, 
	#category : #Development
}

{#category : #private}
BeginningCondition >> compare: aString [
	^aString beginsWith: text
]

{#category : #private}
BeginningCondition >> proposition [
	^'begins with'
]

