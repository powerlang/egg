Class {
	#name : #ExtensionsModule,
	#superclass : #Module,
	#category : #PetitParser
}

{ #category : #spec }
ExtensionsModule >> imports [
	^{
		#Kernel -> #(#CharacterArray #Closure #ReadStream #SequenceableCollection #Symbol #UndefinedObject)
	}
]

{ #category : #initializing }
ExtensionsModule >> initialize [
	super initialize.
	self name: #'PetitParser.Extensions'
]