"
	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #CodeSearchResult, 
	#superclass : #Object, 
	#instVars : [
		'type', 
		'contents'
	], 
	#category : #Development
}

{#category : #'instance creation'}
CodeSearchResult class >> class: aClass [
	^self new type: #class; contents: aClass
]

{#category : #'instance creation'}
CodeSearchResult class >> method: aCompiledMethod [
	^self new type: #method; contents: aCompiledMethod
]

{#category : #'instance creation'}
CodeSearchResult class >> pool: aString [
	^self new type: #pool; contents: aString
]

{#category : #'instance creation'}
CodeSearchResult class >> project: aBeeProject [
	^self new type: #project; contents: aBeeProject
]

{#category : #'instance creation'}
CodeSearchResult class >> selector: aSymbol [
	^self new type: #selector; contents: aSymbol
]

{#category : #accessing}
CodeSearchResult >> contents [
	^contents
]

{#category : #accessing}
CodeSearchResult >> contents: anObject [
	contents := anObject
]

{#category : #printing}
CodeSearchResult >> printOn: aStream [
	aStream
		print: type;
		nextPut: $:;
		space;
		print: contents
]

{#category : #inquiries}
CodeSearchResult >> text [
	^contents asString
]

{#category : #accessing}
CodeSearchResult >> type [
	^type
]

{#category : #accessing}
CodeSearchResult >> type: aSymbol [
	type := aSymbol
]

