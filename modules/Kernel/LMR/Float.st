"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Float }

{ #category : #'*instance creation' }
Float class >> new [
	^self memory newArrayedBytes: instanceBehavior size: 8.
]

