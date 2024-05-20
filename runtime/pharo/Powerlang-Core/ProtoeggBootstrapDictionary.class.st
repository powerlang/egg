Class {
	#name : #ProtoeggBootstrapDictionary,
	#superclass : #ProtoeggObject,
	#instVars : [
		'image',
		'assocs',
		'realSpec',
		'constant'
	],
	#category : #'Powerlang-Core-Execution-Bootstrap-Ring'
}

{ #category : #accessing }
ProtoeggBootstrapDictionary >> associationAt: aSymbol ifAbsent: aBlock [
	^ assocs at: aSymbol ifAbsent: aBlock
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> associationAt: aSymbol ifPresent: aBlock [
	assocs at: aSymbol ifPresent: [:assoc |  ^ aBlock value: assoc ].
	^ nil
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> associations [
	^ assocs values
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> at: aSymbol [
	^self
		at: aSymbol
		ifAbsent: [ self error: aSymbol , ' was not found in dictionary' ]
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> at: aSymbol ifAbsent: aBlock [
	| assoc |
	assoc := assocs
		at: aSymbol
		ifAbsent: [ ^ aBlock value ].
	^ assoc value
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> at: aSymbol ifPresent: aBlock [
	| value |
	value := self at: aSymbol ifAbsent: [ ^ nil ].
	^ aBlock value: value
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> at: aSymbol put: anObject [
	| s assoc value |
	assoc := assocs
		at: aSymbol
		ifAbsentPut: [ s := image newSymbol: aSymbol.
			assoc := image newAssociation: s -> image nil ].
	value := image transferLiteralDeep: anObject.
	assoc value: value .
	^ value
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> beConstant [
	constant := true
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> image: aPowertalkRingImage [
	image := aPowertalkRingImage
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> includesKey: aSymbol [
	^assocs includesKey: aSymbol
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> initialize [
	assocs := Dictionary new.
	constant := false
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> initializeAs: anRGBehavior [
	spec := anRGBehavior
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> isConstant [
	^ constant
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> isDictionaryMap [ 
	^ true
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> keys [
	| keys |
	keys := assocs values collect: #key.
	^image newArray: keys
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> realSpec [
	^realSpec
]

{ #category : #accessing }
ProtoeggBootstrapDictionary >> realSpec: anRGBehavior [
	realSpec := anRGBehavior 
]
