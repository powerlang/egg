"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*Extensions' }
Object >> asParser [
	^ PPPredicateObjectParser expect: self
]

{ #category : '*Extensions' }
Object >> isPetitFailure [
	^ false
]

{ #category : '*Extensions' }
Object >> isPetitParser [
	^ false
]

