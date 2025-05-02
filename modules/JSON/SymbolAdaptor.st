"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SymbolAdaptor,
	#superclass : #DataAdaptor,
	#category : #JSON
}

{ #category : #services }
SymbolAdaptor >> objectFrom: aString [
	^aString asSymbol
]

