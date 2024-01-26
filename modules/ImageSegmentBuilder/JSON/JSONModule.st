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
		#Kernel -> #HashTable.
		#Kernel -> #IdentityDictionary.
	}
]

{ #category : #initializing }
JSONModule >> justLoaded [
	super justLoaded.
	self name: #'ImageSegmentBuilder.JSON'
]
