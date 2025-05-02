Class {
	#name : #JsonModule,
	#superclass : #Module,
	#instVars : [
		''
	],
	#category : #JSON
}

{ #category : #spec }
JsonModule >> imports [
	^{
		#Kernel -> #(Character Error IdentitySet OrderedDictionary).
	}
]

{ #category : #spec }
JsonModule >> justLoaded [
	JsonWriter initializePools
]
