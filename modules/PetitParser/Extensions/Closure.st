"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Extension { #name : #Closure }

{ #category : '*Extensions' }
Closure >> asParser [
	^PPPluggableParser on: self
]

