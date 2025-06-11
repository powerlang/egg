"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Exception }

{ #category : '*SUnit' }
Exception class >> sunitSignalWith: aString [
	self signal: aString
]

{ #category : '*SUnit' }
Exception >> hasNextHandler [
	| next |
	next := self nextHandler.
	^next notNil andNot: [next isSUnitHandler]
]

{ #category : '*SUnit' }
Exception >> sunitExitWith: aValue [
	self return: aValue
]

