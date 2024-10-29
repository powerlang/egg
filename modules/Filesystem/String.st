"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #String }

{ #category : #'instance creation' }
String class >> asFilename [
	^Library pathNew: self
]
