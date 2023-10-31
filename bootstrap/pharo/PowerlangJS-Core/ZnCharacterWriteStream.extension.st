Extension { #name : #ZnCharacterWriteStream }

{ #category : #'*PowerlangJS-Core' }
ZnCharacterWriteStream >> crtab: anInteger [
	self
		cr;
		tab: anInteger
]

{ #category : #'*PowerlangJS-Core' }
ZnCharacterWriteStream >> tab: anInteger [
	anInteger timesRepeat: [ self tab]
]
