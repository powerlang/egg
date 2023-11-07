Class {
	#name : #JSONModule,
	#superclass : #Module,
	#instVars : [
		''
	],
	#category : #'Powerlang-Core-Modules-JSON'
}

{ #category : #spec }
JSONModule >> imports [
	^{
		#Kernel -> #Module.
		#Kernel -> #IdentityDictionary
	}
]

