"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #BindSite,
	#superclass : #Object,
	#instVars : [
		'name',
		'method',
		'association'
	],
	#category : #LMR
}

{ #category : #'instance creation' }
BindSite class >> name: aSymbol method: aCompiledMethod [
	^self new name: aSymbol method: aCompiledMethod
]

{ #category : #accessing }
BindSite >> association [
	^association ifNil: [self lookup]
]

{ #category : #private }
BindSite >> lookup [
	| found |
	found := method associationFor: name.
	found ifNil: [^name -> nil].
	^association := found
]

{ #category : #initialization }
BindSite >> name: aSymbol method: aCompiledMethod [
	name := aSymbol.
	method := aCompiledMethod
]

{ #category : #accessing }
BindSite >> value [
	^self association value
]

{ #category : #accessing }
BindSite >> value: anObject [
	| binding |
	binding := self association.
	association ifNil: [^self error: 'unbound variable ' , name].
	binding value: anObject.
	^anObject
]
