"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Species }

{ #category : #'*webside' }
Species >> asWebsideJson [
	^super asWebsideJson
		at: 'name' put: self name;
		at: 'definition' put: self definitionString;
		at: 'superclass'
		put: (self superclass ifNotNil: [:c | c name]);
		at: 'comment' put: self comment;
		at: 'variable' put: self isVariable;
		at: 'package' put: self module name;
		yourself
]

{ #category : #'*webside' }
Species >> definitionString [
	^String streamContents: [:strm | self fileOutOn: strm]
]
