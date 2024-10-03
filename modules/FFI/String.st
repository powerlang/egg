"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #String }

{ #category : #'instance creation' }
String class >> fromMemory: anExternalMemory [
	| length |
	length := 1.
	[(anExternalMemory at: length) = 0] whileFalse: [length := length + 1].
	^self fromMemory: anExternalMemory length: length - 1
]

{ #category : #'instance creation' }
String class >> fromMemory: anExternalMemory length: anInteger [
	| string |
	string := self new: anInteger.
	string replaceFrom: 1 to: anInteger with: anExternalMemory startingAt: 1.
	^string
]

