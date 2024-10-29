Class {
	#name : #PetitParserModule,
	#superclass : #Module,
	#category : #PetitParser
}

{ #category : #spec }
PetitParserModule >> imports [
	^{
		#Kernel -> #(#InternalReadStream)
	}
]