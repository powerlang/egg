Class {
	#name : #PharoLookup,
	#superclass : #MethodLookup,
	#category : 'Powerlang-Core-Metaphysics',
	#package : 'Powerlang-Core',
	#tag : 'Metaphysics'
}

{ #category : #'meta accessing' }
PharoLookup >> lookup: aSymbol on: aSubject [
	^ aSubject _gate handle oid class lookupSelector: aSymbol
]
