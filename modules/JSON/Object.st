"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*JSON' }
Object class >> defaultMapping [
	^nil
]

{ #category : '*JSON' }
Object >> isJsonObject [
	^false
]

