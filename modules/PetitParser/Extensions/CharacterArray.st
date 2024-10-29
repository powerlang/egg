"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Extension { #name : #CharacterArray }

{ #category : '*Extensions' }
CharacterArray >> copyReplaceAll: aString with: anotherString [
	^self replaceAll: aString with: anotherString

]

{ #category : '*Extensions' }
CharacterArray >> sameAs: aString [
	^self equalsCaseInsensitive: aString
]

