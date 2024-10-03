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
		#Kernel -> #(Module HashTable IdentityDictionary).
		#ImageSegmentBuilder -> #Writer
	}
]

{ #category : #initializing }
JSONModule >> initialize [
	super initialize.
	self name: #'ImageSegmentBuilder.JSON'
]

{ #category : #services }
JSONModule >> newWriter [
	^JSONWriter new
]

{ #category : #services }
JSONModule >> fileExtension [
	^'json'
]