Class {
	#name : #ToolsModule,
	#superclass : #Module,
	#category : #PetitParser
}

{ #category : #spec }
ToolsModule >> imports [
	^{
		#PetitParser.Parsers -> #(#PPDelegateParser #PPParser)
	}
]

{ #category : #initializing }
ToolsModule >> initialize [
	super initialize.
	self name: #'PetitParser.Tools'
]